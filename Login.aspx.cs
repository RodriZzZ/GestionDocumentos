using System;
using System.Linq;
using GestionDocumentos.Data;

namespace GestionDocumentos
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            var ctx = new GestionDocumentosEntities();

            var email = TxtUserEmail.Text;
            var password = TxtUserPassword.Text;

            var existingUser = ctx.Users.FirstOrDefault(usr => usr.institutional_email == email);

            if (existingUser == null)
            {
                lblMensajeError.Text = "No se encontró un usuario con ese correo electrónico.";
                return;
            }

            var hashedInputPassword = HashPassword.Hash(password);

            var validPassword = existingUser.password != hashedInputPassword;

            if (!validPassword)
            {
                lblMensajeError.Text = "Credenciales incorrectas. Si crees que se trata de un error, contacta con el administrador.";
                return;
            }

            Session[SessionKey.UserId] = existingUser.id;
            Response.Redirect("FileDashboard.aspx");
        }
    }
}