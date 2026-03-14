using System;
using System.Linq;
using GestionDocumentos.Data;

namespace GestionDocumentos
{
    public partial class FileDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDocuments();
            }
        }

        protected void BtnUploadFile_Click(object sender, EventArgs e)
        {
            try
            {
                var ctx = new GestionDocumentosEntities();

                /*

                // CORRER ESTO PRIMERO PARA TENER UN USUARIO EN DB
                ctx.sp_CreateUser(
                    firstName: "Admin",
                    lastName: "Admin",
                    email: "admin@admin.com",
                    passwordHash: HashPassword("admin1234"),
                    roleId: 1
                    );


                // LUEGO CORRER ESTO
                var filename = Path.GetFileNameWithoutExtension(FupFile.FileName);
                var extension = Path.GetExtension(FupFile.FileName);

                ctx.sp_UploadNewDocument(
                    name: filename,
                    fileExtension: extension,
                    ownerUserId: 1,
                    fileContent: FupFile.FileBytes,
                    fileSizeInBytes: FupFile.PostedFile.ContentLength
                );
                */
            }
            catch (Exception exception)
            {
                LblFileData.Text = $"Error: {exception.Message}";
            }
        }

        private string HashPassword(string password)
        {
            return BCrypt.Net.BCrypt.HashPassword(password, salt: BCrypt.Net.BCrypt.GenerateSalt(10));
        }

        private void LoadDocuments()
        {
            var ctx = new GestionDocumentosEntities();

            try
            {
                var res = ctx.sp_GetDocumentsByUser(1).ToList();

                GvDocuments.DataSource = res;
                GvDocuments.DataBind();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }

        protected string FormatSize(object fileSizeInBytes)
        {
            if (fileSizeInBytes == null)
                return "0 KB";

            var bytes = Convert.ToDouble(fileSizeInBytes);

            if (bytes >= 1048576) // Si es mayor o igual a 1 MB
                return (bytes / 1048576).ToString("0.##") + " MB";

            if (bytes >= 1024) // Si es mayor o igual a 1 KB
                return (bytes / 1024).ToString("0.##") + " KB";

            return bytes + " Bytes";
        }

    }
}