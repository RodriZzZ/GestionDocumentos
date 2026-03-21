using GestionDocumentos.Data;
using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GestionDocumentos
{
    public partial class FileDashboard : Page
    {
        private int _userId;
        private int EditDocumentId
        {
            get => ViewState["EditDocumentId"] != null ? (int)ViewState["EditDocumentId"] : 0;
            set => ViewState["EditDocumentId"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.ValidateSession(this);

            if (Response.IsRequestBeingRedirected) return;

            _userId = (int)Session[AuthKey.UserId];

            if (!IsPostBack)
            {
                LoadDocuments();
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
        private void LoadDocuments(string filename = null)
        {
            try
            {
                using (var conn = Database.GetConnection())
                {
                    using (var cmd = new SqlCommand("sp_GetDocumentsByUser", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@UserId", _userId);
                        cmd.Parameters.AddWithValue("@SortOption", Convert.ToInt16(DdlSort.SelectedValue));
                        cmd.Parameters.AddWithValue("@FileName", (object)filename ?? DBNull.Value);

                        conn.Open();
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
            LoadDocuments(TxtSearchFile.Text.Trim());
        }

        protected void GvDocuments_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            var documentId = Convert.ToInt32(e.CommandArgument);
            switch (e.CommandName)
            {
                case "DeleteFile":
                    DeleteFile(documentId);
                    break;
                case "NewVersion":
                    EditDocumentId = documentId;
                    ScriptManager.RegisterStartupScript(this, GetType(), "showEditModal",
                        "new bootstrap.Modal(document.getElementById('modalNewVersion')).show();", true);
                    break;
            }
        }

        private void DeleteFile(int documentId)
        {
            try
            {
                using (var conn = Database.GetConnection())
                {
                    using (var cmd = new SqlCommand("sp_DeleteDocument", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.AddWithValue("@DocumentId", documentId);
                        cmd.Parameters.AddWithValue("@UserId", _userId);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                LoadDocuments();
            }
            catch (SqlException ex)
            {
                // TODO: Lbl para error
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        protected void BtnSubmitVersion_Click(object sender, EventArgs e)
        {
            if (!FupNewVersion.HasFile) return;
            if (EditDocumentId == 0) return;

            try
            {
                var file = FupNewVersion.PostedFile;
                var extension = Path.GetExtension(file.FileName); // por si cambia (no deberia, pero es lógica de negocio)
                byte[] fileContent;
                var fileSize = file.ContentLength; // Dejar acá porque despues de hacer el binary reader se resetea a 0

                using (var binaryReader = new BinaryReader(file.InputStream))
                {
                    fileContent = binaryReader.ReadBytes(file.ContentLength);
                }

                using (var conn = Database.GetConnection())
                {
                    using (var cmd = new SqlCommand("sp_AddNewDocumentVersion", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        // Parámetros exactos de tu SP
                        cmd.Parameters.AddWithValue("@DocumentId", EditDocumentId);
                        cmd.Parameters.AddWithValue("@UploadingUserId", _userId);
                        cmd.Parameters.AddWithValue("@FileContent", fileContent);
                        cmd.Parameters.AddWithValue("@FileSizeInBytes", fileSize);
                        cmd.Parameters.AddWithValue("@FileExtension", extension);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                Response.Redirect(Request.RawUrl, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (SqlException ex)
            {
                // LblError
            }
            catch (Exception ex)
            {
                // LblError
            }
        }

        protected void BtnResetFilter_OnClick(object sender, EventArgs e)
        {
            TxtSearchFile.Text = string.Empty;
            DdlSort.SelectedIndex = 0;
            LoadDocuments();
        }

        protected void DdlSort_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDocuments(TxtSearchFile.Text.Trim());
        }
    }
}