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
            if (Session[SessionKey.UserId] == null)
            {
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
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

            if (file == null || file.ContentLength == 0)
            {
                LblFileData.Text = "Por favor, selecciona un archivo válido antes de subirlo.";
                LblFileData.CssClass = "text-warning fw-bold d-block mt-2";
                return;
            }

            try
            {
                var filename = Path.GetFileNameWithoutExtension(file.FileName);
                var extension = Path.GetExtension(file.FileName);
                byte[] fileContent;

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
                        cmd.Parameters.AddWithValue("@FileSizeInBytes", file.ContentLength);

                        conn.Open();
                        cmd.ExecuteScalar();

                    }
                }

                LblFileData.Text = "Archivo subido exitosamente.";
                LblFileData.CssClass = "text-success fw-bold d-block mt-2";

                // // Recargamos la página para limpiar el input y mostrar el nuevo archivo en la grilla
                // Response.Redirect(Request.RawUrl, false);
                // Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception exception)
            {
                LblFileData.Text = $"Error: {exception.Message}";
                LblFileData.CssClass = "text-danger fw-bold d-block mt-2";
            }
        }

        private void LoadDocuments()
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
    }
}