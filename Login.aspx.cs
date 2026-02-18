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
                string correoCorrecto = "example@gmail.com";
                string claveCorrecta = "utec123";

                if (txtUsuario.Text == correoCorrecto && txtPassword.Text == claveCorrecta)
                {
                    Session["Usuario"] = txtUsuario.Text;

                    Response.Redirect("FileDashboard.aspx");
                }
                else
                {
                    lblMensajeError.Text = "Correo o contraseña incorrectos.";
                    lblMensajeError.Visible = true;

                    txtUsuario.Text = "";
                    txtPassword.Focus();
                }
            }
        }
    }
}