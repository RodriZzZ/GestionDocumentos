using GestionDocumentos.Data;
using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

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
                var ctx = new GestionDocumentosEntities();

                var users = ctx.Users
                    .ToList() // -> ef no soporta linq, por eso se parsea a lista
                    .Select(usr => new
                    {
                        Id = usr.id,
                        NombreCompleto = $"{usr.first_name} {usr.last_name}",
                        Email = usr.institutional_email
                    })
                    .OrderByDescending(u => u.Id) // Los más recientes primero
                    .ToList();

                GvUsers.DataSource = users;
                GvUsers.DataBind();
            }
            catch (Exception ex)
            {
                // TODO: cambiar por Label y mensaje adecuado para ui
                Console.WriteLine(ex.Message);
            }
        }

        protected void GvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            var userId = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "EditUser":
                    // Redirigimos al formulario que ya diseñaste, pasándole el ID por la URL
                    Response.Redirect($"AdminUsuarioForm.aspx?id={userId}", false);
                    Context.ApplicationInstance.CompleteRequest();
                    break;
                case "DeleteUser":
                    DeleteUser(userId);
                    break;
                default:
                    break;
            }
        }

        private void DeleteUser(int userId)
        {
            // TODO: borrar archivos de user y usuario
        }
    }
}