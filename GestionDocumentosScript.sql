-- IMPORTANTE: Activar FILESTREAM a nivel de instancia
-- 1. Buscar SQL Server Configuration Manager 
-- 2. Dar click en SQL Server Services
-- 3. Dar click derecho en la instancia activa de SQL Server (la que está corriendo) y dar click en Propiedades/Properties
-- 4. Ir a pestaña de FILESTREAM y activar los dos primeros checkbox's (enable para T-SQL e I/O Access), dejar Windows share name por defecto
-- 5. Reiniciar instancia de SQL (dar click derecho en la instancia al igual que en el paso 3) y dar click en Restart.
-- 6. Correr script en orden.
EXEC sp_configure filestream_access_level, 2;

RECONFIGURE;

-- Creación de db
CREATE DATABASE GestionDocumentos;
USE GestionDocumentos;
SET LANGUAGE us_english;

-- Configuración de FILESTREAM
-- Agrega el Filegroup para FILESTREAM
ALTER DATABASE GestionDocumentos
ADD FILEGROUP GestionDocumentosFSGroup CONTAINS FILESTREAM;

-- Asigna la ruta física donde se guardarán los archivos
-- IMPORTANTE: La carpeta 'C:\server' (o donde se quieran almacenar los archivos) deben existir ANTES de correr esto. 
-- La subcarpeta '\documents' NO debe existir, SQL la creará sola.
ALTER DATABASE GestionDocumentos
ADD FILE (
    NAME = 'GestionDocumentos_FS',
    FILENAME = 'C:\server\documents' -- cambiar por la ruta creada o preferida
)
TO FILEGROUP GestionDocumentosFSGroup;

-- Creación de tablas del sistema

CREATE TABLE Roles (
    id INT PRIMARY KEY,
    name NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Users (
    id INT PRIMARY KEY IDENTITY(1,1),
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    institutional_email NVARCHAR(100) NOT NULL UNIQUE,
    password NVARCHAR(256) NOT NULL, -- Contraseña con hash, no texto plano. 
    role_id INT NOT NULL,
    CONSTRAINT FK_Roles_Users FOREIGN KEY (role_id) REFERENCES Roles(id)
);

-- Metadatos del documento 
CREATE TABLE Documents (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    file_extension VARCHAR(10) NOT NULL,
    owner_user_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Owner_User FOREIGN KEY (owner_user_id) REFERENCES Users(id)
);

-- Historial de versiones y configuración para FILESTREAM
CREATE TABLE DocumentVersion (
    version_id INT PRIMARY KEY IDENTITY(1,1),
    row_id UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE DEFAULT NEWID(),
    document_id INT NOT NULL,
    version_number INT NOT NULL,
    file_content VARBINARY(MAX) FILESTREAM NOT NULL, 
    file_size_in_bytes BIGINT,
    uploaded_at DATETIME DEFAULT GETDATE(),
    uploading_user_id INT NOT NULL,
    
    CONSTRAINT FK_Version_Document FOREIGN KEY (document_id) REFERENCES Documents(id),
    CONSTRAINT FK_Version_Uploading_User FOREIGN KEY (uploading_user_id) REFERENCES Users(id)
);

-- Catalogo para tipos de permisos (1 = Read, 2 = Write, 3 = Owner)
CREATE TABLE DocumentAccess(
    id INT PRIMARY KEY,
    name VARCHAR(25) NOT NULL
);

-- Permisos por usuario y documento
CREATE TABLE UserDocumentAccess (
    id INT PRIMARY KEY IDENTITY(1,1),
    document_id INT NOT NULL,
    access_granted_to_user_id INT NOT NULL,
    permission_id INT NOT NULL,
    access_granted_by_user_id INT NOT NULL, 
    
    CONSTRAINT FK_Document_Access FOREIGN KEY (document_id) REFERENCES Documents(id),
    CONSTRAINT FK_Access_Granted_To_User FOREIGN KEY (access_granted_to_user_id) REFERENCES Users(id),
    CONSTRAINT FK_Access_Granted_By_User FOREIGN KEY (access_granted_by_user_id) REFERENCES Users(id),
    CONSTRAINT FK_Access FOREIGN KEY (permission_id) REFERENCES DocumentAccess(id),
    
    -- Evita que el mismo usuario tenga permisos duplicados en el mismo documento
    CONSTRAINT UQ_Unique_Access_By_User UNIQUE (document_id, access_granted_to_user_id) 
);
GO

CREATE OR ALTER PROCEDURE sp_CreateUser
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(256),
    @RoleId INT
AS
BEGIN
    -- Validar que el correo institucional no exista ya en la base de datos
    IF EXISTS (SELECT 1 FROM Users WHERE institutional_email = @Email)
    BEGIN
        RAISERROR('Error: El correo institucional ya se encuentra registrado.', 16, 1);
        RETURN;
    END;

    -- Validar que el Rol enviado exista en el catálogo
    IF NOT EXISTS (SELECT 1 FROM Roles WHERE id = @RoleId)
    BEGIN
        RAISERROR('Error: El rol especificado no existe en el sistema.', 16, 1);
        RETURN;
    END;

    BEGIN TRY
        INSERT INTO Users (first_name, last_name, institutional_email, password, role_id)
        VALUES (@FirstName, @LastName, @Email, @PasswordHash, @RoleId);

        -- Devolver el ID del usuario recién creado
        SELECT SCOPE_IDENTITY() AS NewUserId;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_UploadNewDocument
    @Name NVARCHAR(255),
    @FileExtension VARCHAR(10),
    @OwnerUserId INT,
    @FileContent VARBINARY(MAX), -- Aquí se enviará el arreglo de bytes (byte[])
    @FileSizeInBytes BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Crear el registro maestro del documento (Metadatos)
        DECLARE @NewDocumentId INT;
        
        INSERT INTO Documents (name, file_extension, owner_user_id)
        VALUES (@Name, @FileExtension, @OwnerUserId);
        
        -- Capturamos el ID del documento recién creado
        SET @NewDocumentId = SCOPE_IDENTITY();

        -- Guardar el archivo físico (FILESTREAM) como la Versión 1
        INSERT INTO DocumentVersion (document_id, version_number, file_content, file_size_in_bytes, uploading_user_id)
        VALUES (@NewDocumentId, 1, @FileContent, @FileSizeInBytes, @OwnerUserId);

        INSERT INTO UserDocumentAccess (document_id, access_granted_to_user_id, permission_id, access_granted_by_user_id)
        VALUES (@NewDocumentId, @OwnerUserId, 3, @OwnerUserId);


        COMMIT TRANSACTION;

        SELECT @NewDocumentId AS NewDocumentId;
        
    END TRY
    BEGIN CATCH
        -- Si ocurrió CUALQUIER error en alguna de las 3 inserciones, deshacemos todo
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_AddNewDocumentVersion
    @DocumentId INT,
    @UploadingUserId INT,
    @FileContent VARBINARY(MAX),
    @FileSizeInBytes BIGINT,
    @FileExtension NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar si el dueño del documento O tiene permiso de escritura
        IF NOT EXISTS (
            SELECT 1 FROM Documents 
            WHERE id = @DocumentId AND owner_user_id = @UploadingUserId
            UNION
            SELECT 1 FROM UserDocumentAccess 
            WHERE document_id = @DocumentId 
              AND access_granted_to_user_id = @UploadingUserId 
              AND permission_id IN (2, 3) -- 2: Write, 3: Owner
        )
        BEGIN
            RAISERROR('No tienes permisos de escritura para actualizar este documento.', 16, 1);
        END

        -- Calcular cuál será la nueva iteración del doc
        DECLARE @NextVersion INT;
        
        SELECT @NextVersion = MAX(version_number) + 1 
        FROM DocumentVersion 
        WHERE document_id = @DocumentId;

        -- Insertar la nueva versión en el historial de versiones
        INSERT INTO DocumentVersion (
            document_id, 
            version_number, 
            file_content, 
            file_size_in_bytes, 
            uploading_user_id
        )
        VALUES (
            @DocumentId, 
            @NextVersion, 
            @FileContent, 
            @FileSizeInBytes, 
            @UploadingUserId
        );

        -- Por si se cambia el archivo, aunque deberia ser la misma extensión
        UPDATE Documents SET file_extension = @FileExtension WHERE id =  @DocumentId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        THROW 51001, @ErrorMessage, 1;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_GetDocumentsByUser
    @UserId INT,
    @FileName NVARCHAR(255) = NULL,
    @SortOption TINYINT = 0
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        d.id AS DocumentId, 
        d.name AS DocumentName, 
        d.file_extension AS FileExtension, 
        v.file_size_in_bytes AS FileSize,
        v.uploaded_at AS UploadDate,
        v.version_number AS VersionNumber
    FROM Documents d
    INNER JOIN DocumentVersion v ON d.id = v.document_id
    WHERE d.owner_user_id = @UserId
      AND (@FileName IS NULL OR d.name LIKE '%' + @FileName + '%')
      -- Aseguramos traer solo la última versión
      AND v.version_number = (SELECT MAX(version_number) FROM DocumentVersion WHERE document_id = d.id)
    ORDER BY 
        CASE WHEN @SortOption = 0 THEN v.uploaded_at END DESC,
        CASE WHEN @SortOption = 1 THEN v.uploaded_at END ASC,
        CASE WHEN @SortOption = 2 THEN d.name END DESC,
        CASE WHEN @SortOption = 3 THEN d.name END ASC;
END;
GO

CREATE OR ALTER PROCEDURE sp_DeleteDocument
    @DocumentId INT,
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION

        -- Validar que el documento exista y que el usuario sea el dueño
        IF NOT EXISTS (SELECT 1 FROM Documents WHERE id = @DocumentId AND owner_user_id = @UserId)
        BEGIN
            RAISERROR('El documento no existe o no tienes permisos para eliminarlo.', 16, 1)
        END

        -- Eliminar permisos si se compartio este documento, se deben borrar primero
        DELETE FROM UserDocumentAccess 
        WHERE document_id = @DocumentId;

        -- Eliminar el historial de versiones y los archivos físicos
        DELETE FROM DocumentVersion 
        WHERE document_id = @DocumentId;

        -- Eliminar el registro maestro del documento
        DELETE FROM Documents 
        WHERE id = @DocumentId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);

    END CATCH
END;
GO

INSERT INTO Roles (id, name) VALUES (1, 'Admin'), (2, 'Empleado'); -- Roles del sistema
INSERT INTO DocumentAccess (id, name) VALUES (1, 'Read'), (2, 'Write'), (3, 'Owner'); -- Permisos de documento (catálogo)
EXEC sp_CreateUser 'admin', 'admin', 'admin@admin.com', '$2a$10$uR.piytfSUJIB3n7W7YF2ejLm/eI5iVm.YNC3MOAOqNjPHafYPTv6', 1; -- contraseña es admin1234 para usarla en la app