using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using GestionDocumentos.Data;

namespace GestionDocumentos
{
    public partial class AdminUsuarioForm : Page
    {
        private int _editUserId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session[SessionKey.UserRole] == null || (SystemRoles)Session[SessionKey.UserRole] != SystemRoles.Admin)
            {
                Response.Redirect("FileDashboard.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (Request.QueryString["id"] != null)
            {
                int.TryParse(Request.QueryString["id"], out _editUserId);
            }

            if (IsPostBack) return;

            LoadRoles();

            if (_editUserId > 0)
            {
                LoadUserData(_editUserId);
                LblTitle.Text = $"Actualizar usuario {_editUserId}";
                BtnUpsertUser.Text = "Actualizar usuario";
                ReqPassword.Enabled = false;
            }
            else
            {
                LblTitle.Text = "Crear usuario";
                BtnUpsertUser.Text = "Guardar usuario";
            }
        }

        private void LoadUserData(int editUserId)
        {
            try
            {
                using (var conn = Database.GetConnection())
                {
                    const string query = "SELECT institutional_email, first_name, last_name, role_id FROM Users WHERE id = @id";

                    using (var cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", editUserId);

                        conn.Open();
                        using (var reader = cmd.ExecuteReader())
                        {
                            if (!reader.Read()) return;
                            TxtUserEmail.Text = reader["institutional_email"].ToString();
                            TxtUserFirstName.Text = reader["first_name"].ToString();
                            TxtUserLastName.Text = reader["last_name"].ToString();
                            DdlRole.SelectedValue = reader["role_id"].ToString();
                        }
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }
        }

        private void LoadRoles()
        {
            try
            {
                using (var conn = Database.GetConnection())
                {
                    const string query = "SELECT id, name FROM Roles";

                    using (var cmd = new SqlCommand(query, conn))
                    {
                        using (var sda = new SqlDataAdapter(cmd))
                        {
                            var dtRoles = new DataTable();
                            sda.Fill(dtRoles);

                            DdlRole.Items.Clear();
                            DdlRole.DataSource = dtRoles;
                            DdlRole.DataTextField = "name";
                            DdlRole.DataValueField = "id";
                            DdlRole.DataBind();
                        }
                    }
                }

                DdlRole.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Selecciona un rol", "0"));
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }
        }

        protected void BtnUpsertUser_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                LblError.Text = string.Empty;

                var firstName = TxtUserFirstName.Text.Trim();
                var lastName = TxtUserLastName.Text.Trim();
                var email = TxtUserEmail.Text.Trim();
                var password = TxtPassword.Text;
                var roleId = Convert.ToInt16(DdlRole.SelectedItem.Value);

                using (var conn = Database.GetConnection())
                {
                    conn.Open();

                    if (_editUserId == 0)
                    {
                        // Usamos el Stored Procedure para crear
                        using (SqlCommand cmd = new SqlCommand("sp_CreateUser", conn))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;

                            cmd.Parameters.AddWithValue("@FirstName", firstName);
                            cmd.Parameters.AddWithValue("@LastName", lastName);
                            cmd.Parameters.AddWithValue("@Email", email);
                            cmd.Parameters.AddWithValue("@PasswordHash", HashPassword.Hash(password));
                            cmd.Parameters.AddWithValue("@RoleId", roleId);

                            cmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        // Actualización dinámica dependiendo de si ingresó contraseña nueva o no
                        var updateQuery = "UPDATE Users SET first_name = @firstName, last_name = @lastName, institutional_email = @email, role_id = @roleId";

                        if (!string.IsNullOrWhiteSpace(password))
                        {
                            updateQuery += ", password = @password";
                        }
                        updateQuery += " WHERE id = @id";

                        using (var cmd = new SqlCommand(updateQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@firstName", firstName);
                            cmd.Parameters.AddWithValue("@lastName", lastName);
                            cmd.Parameters.AddWithValue("@email", email);
                            cmd.Parameters.AddWithValue("@roleId", roleId);
                            cmd.Parameters.AddWithValue("@id", _editUserId);

                            if (!string.IsNullOrWhiteSpace(password))
                            {
                                cmd.Parameters.AddWithValue("@password", HashPassword.Hash(password));
                            }

                            var rowsAffected = cmd.ExecuteNonQuery();

                            if (rowsAffected == 0)
                            {
                                LblError.Text = $"No se encontró al usuario {_editUserId}";
                                return;
                            }
                        }
                    }
                }

                Response.Redirect("AdminUsuarios.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception exception)
            {
                LblError.Text = exception.Message;
            }
        }
    }
}