using ActvWebApi.DbSupport;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ActvWebApi.DbSupport
{
    public class ACTVDBQueryHelper
    {
        private SQLBaseTable sqlBaseTableObj = null;
        private string conn = "";

        public ACTVDBQueryHelper()
        {
            conn = System.Configuration.ConfigurationManager.ConnectionStrings["ActvDbCon"].ConnectionString;//Program.ConString;
            sqlBaseTableObj = new SQLBaseTable(conn);
        }

        public DataTable ExecuteSelectStatement(string queryString)
        {
            DataTable resultDataTable = null;
            try
            {
                resultDataTable = sqlBaseTableObj.SelectObject(queryString);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return resultDataTable;
        }

        public bool ExecuteNonSelectStatement(string queryString)
        {
            bool result = false;
            try
            {
                result = sqlBaseTableObj.ExecuteNonQuery(queryString);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }
    }
}