using System;
using System.Data.SqlClient;
using System.Web.UI;
using GestionDocumentos.Data;

namespace GestionDocumentos
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            // Limpiamos los espacios en blanco del correo por seguridad
            var email = TxtUserEmail.Text.Trim();
            var password = TxtUserPassword.Text;

            try
            {
                using (var conn = Database.GetConnection())
                {
                    const string query = "SELECT id, password, role_id FROM Users WHERE institutional_email = @email";

                    using (var cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@email", email);

                        conn.Open();
                        using (var reader = cmd.ExecuteReader())
                        {
                            if (reader.Read()) 
                            {
                                var dbPasswordHash = reader["password"].ToString();
                                var userId = Convert.ToInt32(reader["id"]);
                                var roleId = Convert.ToInt32(reader["role_id"]);

                                if (!BCrypt.Net.BCrypt.Verify(password, dbPasswordHash))
                                {
                                    lblMensajeError.Text = "Credenciales incorrectas. Si crees que se trata de un error, contacta con el administrador.";
                                    return;
                                }

                                // Si todo está bien, asignamos las sesiones
                                Session[SessionKey.UserId] = userId;
                                Session[SessionKey.UserRole] = roleId;
                                Response.Redirect("FileDashboard.aspx", false);
                                Context.ApplicationInstance.CompleteRequest();
                            }
                            else
                            {
                                lblMensajeError.Text = "No se encontró un usuario con ese correo electrónico.";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                lblMensajeError.Text = "Ocurrió un error al intentar iniciar sesión. Por favor, intenta más tarde.";
            }
        }
    }
}