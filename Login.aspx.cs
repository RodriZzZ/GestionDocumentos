using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GestionDocumentos
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //Page_Load
        }
        protected void btnLogin_Click(object sender, EventArgs e)
        { 
            if (Page.IsValid)
            {
                if (txtUsuario.Text == "admin" && txtPassword.Text == "12345")
                {
                    Session["Usuario"] = txtUsuario.Text;

                    Response.Redirect("Dashboard.aspx");
                }
                else
                {
                    // Label de error
                }
            }
        }
    }
}