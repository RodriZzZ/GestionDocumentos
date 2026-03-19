using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using GestionDocumentos.Data;

namespace GestionDocumentos
{
    public partial class AdminUsuarios : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session[SessionKey.UserRole] == null || (SystemRoles)Session[SessionKey.UserRole] != SystemRoles.Admin)
            {
                Response.Redirect("FileDashboard.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                LoadUsers();
            }
        }

        private void LoadUsers()
        {
            try
            {
                using (var conn = Database.GetConnection())
                {
                    const string query = @"
                        SELECT 
                            id AS Id, 
                            first_name + ' ' + last_name AS NombreCompleto, 
                            institutional_email AS Email
                        FROM Users 
                        ORDER BY id DESC";

                    using (var cmd = new SqlCommand(query, conn))
                    {
                        using (var sda = new SqlDataAdapter(cmd))
                        {
                            var dtUsers = new DataTable();
                            sda.Fill(dtUsers);

                            GvUsers.DataSource = dtUsers;
                            GvUsers.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        protected void GvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (string.IsNullOrEmpty(e.CommandArgument?.ToString())) return;

            var userId = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "EditUser":
                    Response.Redirect($"AdminUsuarioForm.aspx?id={userId}", false);
                    Context.ApplicationInstance.CompleteRequest();
                    break;
                case "DeleteUser":
                    DeleteUser(userId);
                    LoadUsers();
                    break;
            }
        }

        private static void DeleteUser(int userId)
        {
            using (var conn = Database.GetConnection())
            {
                conn.Open();
                using (var transaction = conn.BeginTransaction())
                {
                    try
                    {
                        // 1. Borrar archivos asociados al usuario 
                        const string deleteDocsQuery = "DELETE FROM Documents WHERE owner_user_id = @userId";
                        using (var cmdDocs = new SqlCommand(deleteDocsQuery, conn, transaction))
                        {
                            cmdDocs.Parameters.AddWithValue("@userId", userId);
                            cmdDocs.ExecuteNonQuery();
                        }

                        // 2. Borrar al usuario
                        const string deleteUserQuery = "DELETE FROM Users WHERE id = @userId";
                        using (var cmdUser = new SqlCommand(deleteUserQuery, conn, transaction))
                        {
                            cmdUser.Parameters.AddWithValue("@userId", userId);
                            cmdUser.ExecuteNonQuery();
                        }

                        // Si llegamos hasta aquí, todo salió bien. Confirmamos los cambios.
                        transaction.Commit();
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        Console.WriteLine(ex.Message);
                    }
                }
            }
        }
    }
}