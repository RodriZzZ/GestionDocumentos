using GestionDocumentos.Data;
using System;
using System.Linq;
using System.Web.UI;

namespace GestionDocumentos
{
    public partial class AdminUsuarioEdit : Page
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
                LoadRoles();
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

        protected void BtnSaveUser_Click(object sender, EventArgs e)
        {

            if (!Page.IsValid) return;
            LblError.Text = string.Empty;

            var firstName = TxtUserFirstName.Text;
            var lastName = TxtUserLastName.Text;
            var email = TxtUserEmail.Text;
            var password = TxtPassword.Text;
            var roleId = Convert.ToInt16(DdlRole.SelectedItem.Value);

            try
            {
                var ctx = new GestionDocumentosEntities();
                ctx.sp_CreateUser(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    passwordHash: HashPassword.Hash(password),
                    roleId: roleId
                    );

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