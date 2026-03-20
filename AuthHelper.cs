using System;
using System.Web;
using System.Web.UI;
using GestionDocumentos.Data;

namespace GestionDocumentos
{
    public static class AuthHelper
    {
        /// <summary>
        /// Verifica si hay una sesión activa. Si no la hay, intenta recuperarla de la cookie.
        /// Si ambas fallan, redirige al Login.
        /// </summary>
        public static void ValidateSession(Page page)
        {
            var session = page.Session;
            var request = page.Request;
            var response = page.Response;

            // Si ya hay sesión en memoria, no hacemos nada más
            if (session[AuthKey.UserId] != null && session[AuthKey.UserRole] != null) return;

            // Si no hay sesión, buscamos la cookie
            var authCookie = request.Cookies[AuthKey.SessionCookie];
            if (
                authCookie != null &&
                !string.IsNullOrEmpty(authCookie[AuthKey.UserId]) && 
                !string.IsNullOrEmpty(authCookie[AuthKey.UserRole])
                )
            {
                // Re-hidratamos la sesión desde la cookie
                session[AuthKey.UserId] = Convert.ToInt32(authCookie[AuthKey.UserId]);
                session[AuthKey.UserRole] = Convert.ToInt16(authCookie[AuthKey.UserRole]);

                if (authCookie[AuthKey.UserName] != null)
                {
                    session[AuthKey.UserName] = authCookie[AuthKey.UserName];
                }
                return;
            }

            response.Redirect("Login.aspx", false);
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }


        /// <summary>
        /// Valida que el usuario en sesión sea un admin
        /// </summary>
        /// <param name="page"></param>
        /// <returns></returns>

        public static void ValidateAdmin(Page page)
        {
            ValidateSession(page);
            var role = Convert.ToInt16(page.Session[AuthKey.UserRole]);

            if (role == (int)SystemRoles.Admin) return;

            page.Response.Redirect("FileDashboard.aspx", false);
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }

        /// <summary>
        /// Inicializa la cookie y Session desde el login
        /// </summary>
        /// <param name="page"></param>
        /// <param name="userId"></param>
        /// <param name="roleId"></param>
        public static void Login(Page page, int userId, int roleId)
        {

            page.Session[AuthKey.UserId] = userId;
            page.Session[AuthKey.UserRole] = roleId;

            var authCookie = new HttpCookie(AuthKey.SessionCookie)
            {
                [AuthKey.UserId] = userId.ToString(),
                [AuthKey.UserRole] = roleId.ToString(),
                Expires = DateTime.Now.AddDays(1),
                HttpOnly = true
            };

            // Añadimos la cookie a la respuesta
            page.Response.Cookies.Add(authCookie);
        }
    }
}