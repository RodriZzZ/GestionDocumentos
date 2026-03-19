using System.Configuration;
using System.Data.SqlClient;

namespace GestionDocumentos.Data
{
    public static class Database
    {
        private static string DbConnectionString = "GestionDocumentosCadenaDB";
        public static SqlConnection GetConnection()
        {
            return new SqlConnection(ConfigurationManager.ConnectionStrings[DbConnectionString].ConnectionString);
        }
    }
}