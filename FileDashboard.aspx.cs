using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using GestionDocumentos.Data;

namespace GestionDocumentos
{
    public partial class FileDashboard : Page
    {
        private int _userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.ValidateSession(this);

            if (Response.IsRequestBeingRedirected) return;

            _userId = (int)Session[AuthKey.UserId];

            if (!IsPostBack)
            {
                LoadAllDocuments();
            }
        }

        protected void BtnUploadFile_Click(object sender, EventArgs e)
        {
            if (!FupFile.HasFile)
            {
                LblFileData.Text = "Por favor, selecciona un archivo válido antes de subirlo.";
                LblFileData.CssClass = "text-warning fw-bold d-block mt-2";
                return;
            }

            try
            {
                var file = FupFile.PostedFile;

                var filename = Path.GetFileNameWithoutExtension(file.FileName);
                var extension = Path.GetExtension(file.FileName);
                byte[] fileContent;
                var fileSize = file.ContentLength; // Dejar acá porque despues de hacer el binary reader se resetea a 0

                using (var binaryReader = new BinaryReader(file.InputStream))
                {
                    fileContent = binaryReader.ReadBytes(file.ContentLength);
                }

                using (var conn = Database.GetConnection()) 
                {
                    using (var cmd = new SqlCommand("sp_UploadNewDocument", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                
                        cmd.Parameters.AddWithValue("@Name", filename);
                        cmd.Parameters.AddWithValue("@FileExtension", extension);
                        cmd.Parameters.AddWithValue("@OwnerUserId", _userId);
                        cmd.Parameters.AddWithValue("@FileContent", fileContent);
                        cmd.Parameters.AddWithValue("@FileSizeInBytes", fileSize);
                
                        conn.Open();
                        cmd.ExecuteNonQuery(); 
                    }
                }

                // El Response.Redirect para limpiar el buffer del FileUpload 
                // y evitar que se resuba el archivo si el usuario presiona F5
                Response.Redirect(Request.RawUrl, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception exception)
            {
                LblFileData.Text = $"Error: {exception.Message}";
                LblFileData.CssClass = "text-danger fw-bold d-block mt-2";
            }
        }
        private void LoadAllDocuments()
        {
            try
            {
                using (var conn = Database.GetConnection())
                {
                    using (var cmd = new SqlCommand("sp_GetDocumentsByUser", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@UserId", _userId);

                        using (var sda = new SqlDataAdapter(cmd))
                        {
                            var dtDocuments = new DataTable();
                            sda.Fill(dtDocuments);

                            GvDocuments.DataSource = dtDocuments;
                            GvDocuments.DataBind();
                        }
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }

        protected string FormatSize(object fileSizeInBytes)
        {
            if (fileSizeInBytes == null || fileSizeInBytes == DBNull.Value)
                return "0 KB";

            var bytes = Convert.ToDouble(fileSizeInBytes);

            if (bytes >= 1048576) // Si es mayor o igual a 1 MB
                return (bytes / 1048576).ToString("0.##") + " MB";

            if (bytes >= 1024) // Si es mayor o igual a 1 KB
                return (bytes / 1024).ToString("0.##") + " KB";

            return bytes + " Bytes";
        }

        protected void BtnSearchFile_OnClick(object sender, EventArgs e)
        {
            var fileName = TxtSearchFile.Text.Trim();

            if (string.IsNullOrWhiteSpace(fileName))
            {
                LoadAllDocuments();
                return;
            }

            try
            {
                using (var conn = Database.GetConnection())
                {
                    // TODO: Pasar a sp
                    const string query = @"
                                SELECT 
                                    d.id AS DocumentId, 
                                    d.name AS DocumentName, 
                                    d.file_extension AS FileExtension, 
                                    v.file_size_in_bytes AS FileSize,
                                    v.uploaded_at AS UploadDate,
                                    v.version_number AS VersionNumber
                                FROM Documents d
                                INNER JOIN DocumentVersion v ON d.id = v.document_id
                                WHERE d.owner_user_id = @userId
                                AND d.name LIKE '%' + @fileName + '%'";

                    using (var cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@userId", _userId);
                        cmd.Parameters.AddWithValue("@fileName", fileName);


                        using (var sda = new SqlDataAdapter(cmd))
                        {
                            var dtDocuments = new DataTable();
                            sda.Fill(dtDocuments);

                            GvDocuments.DataSource = dtDocuments;
                            GvDocuments.DataBind();
                        }
                    }
                }
            }
            catch (Exception exception)
            {
                LblFileData.Text = "Error en la búsqueda: " + exception.Message;
                LblFileData.CssClass = "text-danger";
            }
        }
    }
}