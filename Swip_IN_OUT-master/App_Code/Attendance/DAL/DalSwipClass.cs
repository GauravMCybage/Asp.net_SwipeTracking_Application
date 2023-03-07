using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Common.SwipInSwipOut1;

namespace DieDataAccessLayer
{
    public class DalSwipInOutClass : DALConnection
    {
        string TotalHrs;
        public bool InsertSwipInData()
        {
            bool IsInsert = false;

            SqlConnection conn = GetConnection();
            SqlCommand cmd = new SqlCommand("SP_SWIP_IN", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
                IsInsert = true;
            }
            catch (Exception ex)
            {   
            }
            finally
            {
                conn.Close();
                conn = null;
                cmd = null;
            }

            return IsInsert;
        }

        public bool InsertSwipOutData()
        {
            bool IsInsert = false;

            SqlConnection conn = GetConnection();
            SqlCommand cmd = new SqlCommand("SP_SWIP_OUT", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            try
            {
                // open the connection and execute the command
                conn.Open();
                cmd.ExecuteNonQuery();
                IsInsert = true;
            }
            catch (Exception ex)
            {
                
            }
            finally
            {
                conn.Close();
                conn = null;
                cmd = null;
            }

            return IsInsert;
        }

        public string GetTotalCompletedHr()
        {           

            SqlConnection conn = GetConnection();
            SqlCommand cmd = new SqlCommand("SP_Completed_Hrs", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlParameter CompletedHr = new SqlParameter("@CompletedHr", SqlDbType.VarChar, 50);
            CompletedHr.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(CompletedHr).Value = "8/01/23";
            try
            {
                // open the connection and execute the command
                conn.Open();
                cmd.ExecuteNonQuery();
                TotalHrs= Convert.ToString(cmd.Parameters["@CompletedHr"].Value);
            }
            catch (Exception ex)
            {

            }
            finally
            {
                conn.Close();
                conn = null;
                cmd = null;
            }

            return TotalHrs;
        }

        //public SwipInSwipOut1 GetTodaysAllSWipInOutData()
        //{
        //    SwipInSwipOut1 swipobj = new SwipInSwipOut1();
        //    SqlConnection conn = GetConnection();
        //    SqlCommand cmd = new SqlCommand("GetSwipIN_OutData", conn);
        //    cmd.CommandType = CommandType.StoredProcedure;             
        //    try
        //    {
        //        SqlDataAdapter da = new SqlDataAdapter(cmd);
        //        DataSet ds = new DataSet();
        //        da.Fill(ds);
        //        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        //        {
        //            swipobj.Swipe_In =Convert.ToDateTime(ds.Tables[0].Rows[i]["Swipe_In"]);
        //            if (!(String.IsNullOrEmpty(ds.Tables[0].Rows[i]["Swipe_Out"].ToString())))
        //            {
        //                swipobj.Swipe_Out = Convert.ToDateTime(ds.Tables[0].Rows[i]["Swipe_Out"]);
        //            }
                    
        //        }
        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //    finally
        //    {
        //        conn.Close();
        //        conn = null;
        //        cmd = null;
        //    }
        //    return swipobj;
        //}
    }
}