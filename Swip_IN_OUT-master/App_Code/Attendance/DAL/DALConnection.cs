using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace DieDataAccessLayer
{
    public class DALConnection
    {
        private SqlConnection con;
        public SqlConnection GetConnection()
        {
            string constr = ConfigurationManager.ConnectionStrings["connAttendance"].ToString();
            con = new SqlConnection(constr);
            return con;
        }
    }
}