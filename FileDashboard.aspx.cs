using System;
using System.IO;
using System.Linq;
using GestionDocumentos.Data;
using WebGrease;

namespace GestionDocumentos
{
    public partial class FileDashboard : System.Web.UI.Page
    {

        private int? _userId;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session[SessionKey.UserId] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            _userId = (int)Session[SessionKey.UserId];

            if (!IsPostBack)
            {
                LoadDocuments();
            }
        }

        protected void BtnUploadFile_Click(object sender, EventArgs e)
        {
            var file = InputFile.PostedFile;
            if (file == null)
            {
                LblFileData.Text = "Por favor, selecciona un archivo antes de subirlo.";
                LblFileData.CssClass = "text-warning fw-bold d-block mt-2";
                return;
            }

            try
            {
                var ctx = new GestionDocumentosEntities();

                var filename = Path.GetFileNameWithoutExtension(file.FileName);
                var extension = Path.GetExtension(file.FileName);

                var binaryReader = new BinaryReader(file.InputStream);
                var fileContent = binaryReader.ReadBytes(file.ContentLength);

                var id = ctx.sp_UploadNewDocument(
                    name: filename,
                    fileExtension: extension,
                    ownerUserId: _userId,
                    fileContent: fileContent,
                    fileSizeInBytes: file.ContentLength
                ).FirstOrDefault();

                LblFileData.Text = "Archivo subido exitosamente.";

                Response.Redirect(Request.RawUrl);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception exception)
            {
                LblFileData.Text = $"Error: {exception.Message}";
            }
        }

        private void LoadDocuments()
        {
            var ctx = new GestionDocumentosEntities();

            try
            {
                var res = ctx.sp_GetDocumentsByUser(_userId).ToList();

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