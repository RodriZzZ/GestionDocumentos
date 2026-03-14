using System;
using System.IO;
using System.Linq;
using GestionDocumentos.Data;

namespace GestionDocumentos
{
    public partial class FileDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnUploadFile_Click(object sender, EventArgs e)
        {
            try
            {
                var ctx = new GestionDocumentosEntities();

                var filename = Path.GetFileNameWithoutExtension(FupFile.FileName);
                var extension = Path.GetExtension(FupFile.FileName);

                var id = ctx.sp_UploadNewDocument(
                    name: filename,
                    fileExtension: extension,
                    ownerUserId: 1,
                    fileContent: FupFile.FileBytes,
                    fileSizeInBytes: FupFile.PostedFile.ContentLength
                ).FirstOrDefault();

                LblFileData.Text = id.ToString();
            }
            catch (Exception exception)
            {
                LblFileData.Text = $"Error: {exception.Message}";
            }
        }

    }
}