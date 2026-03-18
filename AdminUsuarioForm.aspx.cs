using GestionDocumentos.Data;
using System;
using System.Linq;
using System.Web.UI;

namespace GestionDocumentos
{
    public partial class AdminUsuarioEdit : Page
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
                var ctx = new GestionDocumentosEntities();

                var user = ctx.Users.Find(editUserId);

                if (user == null) return;

                TxtUserEmail.Text = user.institutional_email;
                TxtUserFirstName.Text = user.first_name;
                TxtUserLastName.Text = user.last_name;
                DdlRole.SelectedValue = user.role_id.ToString();
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }
        }

        private void LoadRoles()
        {
            var ctx = new GestionDocumentosEntities();

            var roles = ctx.Roles.ToList();

            DdlRole.Items.Clear();

            DdlRole.DataSource = roles;
            DdlRole.DataTextField = "name";
            DdlRole.DataValueField = "id";  
            DdlRole.DataBind();
            DdlRole.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Selecciona un rol", "0"));
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

                var ctx = new GestionDocumentosEntities();

                if (_editUserId == 0)
                {
                    ctx.sp_CreateUser(
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        passwordHash: HashPassword.Hash(password),
                        roleId: roleId
                    );
                }
                else
                {
                    var editUser = ctx.Users.Find(_editUserId);

                    if (editUser == null)
                    {
                        LblError.Text = $"No se encontró al usuario {_editUserId}";
                        return;
                    }

                    editUser.first_name = firstName;
                    editUser.last_name = lastName;
                    editUser.institutional_email = email;
                    editUser.role_id = roleId;

                    if (!string.IsNullOrWhiteSpace(password))
                    {
                        editUser.password = HashPassword.Hash(password);
                    }

                    ctx.SaveChanges();
                }

                Response.Redirect("AdminUsuarios.aspx");
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception exception)
            {
                LblError.Text = exception.Message;
            }
        }
    }
}