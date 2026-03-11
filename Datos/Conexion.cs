using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace GestionDocumentos.Datos
{
    public class Conexion
    {
        private readonly string cadena = ConfigurationManager.ConnectionStrings["CadenaGestion"].ConnectionString;

        public SqlConnection EstablecerConexion()
        {
            return new SqlConnection(cadena);
        }
    }
}