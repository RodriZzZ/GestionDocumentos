using System;
using GestionDocumentos.Data;

namespace GestionDocumentos
{
    public partial class MenuPrincipal : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e) 
        {
            if (!IsPostBack)
            {
                ConfigMenu();
            }
        }

        private void ConfigMenu()
        {
            if (Session[SessionKey.UserRole] != null)
            {
                var role = (SystemRoles)Session[SessionKey.UserRole];
                if (role == SystemRoles.Admin) return;

                LiDocumentType.Visible = false;
                LiUsers.Visible = false;
            }
            else
            {
                LiUsers.Visible = false;
                LiDocumentType.Visible = false;
            }
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Remove(SessionKey.UserId);
            Session.Remove(SessionKey.UserRole);
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}