using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ActvMvcClient.SqlHelper
{
    public class SQLBaseTable
    {
        private SqlConnection sqlConnection = new SqlConnection();

        protected SqlConnection SqlConnectionObj
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        public string ConnectionString { get; set; }

        public SQLBaseTable(string _connString)
        {
            PrepareConnection(_connString);
        }

        public string TableName { get; set; }

        private void PrepareConnection(string _connString)
        {
            ConnectionString = _connString;
            sqlConnection.ConnectionString = ConnectionString;
        }

        public void OpenConnection()
        {
            if (SqlConnectionObj.State == ConnectionState.Closed)
                SqlConnectionObj.Open();
        }

        public void CloseConnection()
        {
            if (SqlConnectionObj.State == ConnectionState.Open)
                SqlConnectionObj.Close();
        }

        public bool ExecuteNonQuery(string query)
        {
            SqlCommand tmpCmd = new SqlCommand(query, SqlConnectionObj);
            try
            {
                if (!(SqlConnectionObj.State == ConnectionState.Open))
                {
                    SqlConnectionObj.Open();
                }
                int res = tmpCmd.ExecuteNonQuery();
                if (res > 0)
                    return true;
                else
                    return false;
            }
            catch
            {
                throw;
            }
            finally
            {
                if (!(SqlConnectionObj.State == ConnectionState.Closed))
                {
                    SqlConnectionObj.Close();
                }
            }
        }

        public DataTable SelectObject(string query)
        {
            SqlCommand tmpCmd = new SqlCommand(query, SqlConnectionObj);
            SqlDataAdapter da = new SqlDataAdapter(tmpCmd);
            DataTable result = new DataTable();
            try
            {
                da.Fill(result);
            }
            catch
            {
                throw;
            }
            return result;
        }

        public DataSet SelectObject(string query, out SqlDataAdapter dataAdapter)
        {
            SqlDataAdapter da = new SqlDataAdapter(query, SqlConnectionObj);
            dataAdapter = da;
            SqlCommandBuilder builder = new SqlCommandBuilder(dataAdapter);
            builder.QuotePrefix = "[";
            builder.QuoteSuffix = "]";
            DataSet result = new DataSet();
            try
            {
                da.Fill(result);
            }
            catch
            {
                throw;
            }
            return result;
        }

        public void UpdateTable(DataSet dataSet, SqlDataAdapter adapter)
        {
            if (dataSet != null && adapter != null)
            {
                try
                {
                    adapter.Update(dataSet);
                }
                catch
                {
                    throw;
                }
            }
        }

        public DataSet SelectDataSet(string query)
        {
            SqlCommand tmpCmd = new SqlCommand(query, SqlConnectionObj);
            SqlDataAdapter da = new SqlDataAdapter(tmpCmd);
            DataSet result = new DataSet();
            try
            {
                da.Fill(result);
            }
            catch
            {
                throw;
            }
            return result;
        }

        public bool IsTableExist(string tableName)
        {
            bool isTableExist = false;
            string query = string.Format("SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[{0}]') AND type in (N'U')", tableName);
            DataTable table = SelectObject(query);
            if (table != null && table.Rows.Count > 0)
                isTableExist = true;
            return isTableExist;
        }
    }
}