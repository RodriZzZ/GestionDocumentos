using GestionDocumentos.Data;
using System;
using System.Web;
using System.Web.UI;

namespace GestionDocumentos
{
    public partial class MenuPrincipal : MasterPage
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
            if (Session[AuthKey.UserRole] == null)
            {
                LiUsers.Visible = false;
            }

            var role = Convert.ToInt16(Session[AuthKey.UserRole]);
            if (role == 1) return;

            LiUsers.Visible = false;
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            if (Request.Cookies[AuthKey.SessionCookie] != null)
            {
                var expiredCookie = new HttpCookie(AuthKey.SessionCookie)
                {
                    Expires = DateTime.Now.AddDays(-1) 
                };
                Response.Cookies.Add(expiredCookie);
            }

            Response.Redirect("Login.aspx");
        }
    }
}