using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GestionDocumentos
{
    public static class HashPassword
    {
        public static string Hash(string password)
        {
            return BCrypt.Net.BCrypt.HashPassword(password, salt: BCrypt.Net.BCrypt.GenerateSalt(10));
        }
    }
}