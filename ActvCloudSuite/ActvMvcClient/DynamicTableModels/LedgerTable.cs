using ActvMvcClient.Models;
using ActvMvcClient.SqlHelper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ActvMvcClient.DynamicTableModels
{
    public class LedgerTable : SQLBaseTable
    {
        public int ID { get; set; }
        public int CustID { get; set; }
        public int CustCode { get; set; }
        public int AreaCode { get; set; }
        public string AgentCode { get; set; }
        public int OldBalance { get; set; }
        public string OldBalancePaymentDetails { get; set; }
        public int NumOfMonthsBal { get; set; }
        public int TotalBalance { get; set; }
        public int TotalAmtPaid { get; set; }        

        public BillNumberClass Bill;
        public AmountClass Amt;
        public DateClass Date;
        public BalanceClass Bal;

        private ActvMvcClientEntities db = new ActvMvcClientEntities();
        private const string companyNameConst = "LedgerTable_";
        private SqlDataAdapter ledgerAdapter;
        private DataSet ledgerDataSet;

        //CustomerDetailsTable object
        private CustomerDetailsTable customerDetails = null;

        private DataTable cachedDataTable = null;

        public static string NotPaid { get { return "np"; } }
        public static string NotApplicable { get { return "na"; } }

        private CompanyTable _companyTable;

        public CompanyTable Company
        {
            get
            {
                return _companyTable;
            }
        }

        public string CompanyNamePrefix
        {
            get
            {
                return companyNameConst;
            }
        }

        public string DuplicateBillNumber { get; set; }
        public string DuplicateBillDate { get; set; }
        public int DuplicateBillMonth { get; set; }
        public string DuplicateBillAmt { get; set; }

        public LedgerTable(string connectionString) : base(connectionString)
        {
            //ConnectionString = db.Database.Connection.ConnectionString;
            customerDetails = new CustomerDetailsTable();
            InitLedgerToDefaultValues();
        }

        public LedgerTable CreateCopy()
        {
            LedgerTable ledgerCopy = new LedgerTable(ConnectionString);
            ledgerCopy.ID = ID;
            ledgerCopy.CustID = CustID;
            ledgerCopy.CustCode = CustCode;
            ledgerCopy.AreaCode = AreaCode;
            ledgerCopy.AgentCode = AgentCode;
            ledgerCopy.OldBalance = OldBalance;
            ledgerCopy.OldBalancePaymentDetails = OldBalancePaymentDetails;
            ledgerCopy.NumOfMonthsBal = NumOfMonthsBal;
            ledgerCopy.TotalBalance = TotalBalance;
            ledgerCopy.TotalAmtPaid = TotalAmtPaid;
            ledgerCopy.ConnectionString = ConnectionString;
            ledgerCopy.TableName = TableName;
            ledgerCopy.DuplicateBillDate = DuplicateBillDate;
            ledgerCopy.DuplicateBillMonth = DuplicateBillMonth;
            ledgerCopy.DuplicateBillNumber = DuplicateBillNumber;
            ledgerCopy.DuplicateBillAmt = DuplicateBillAmt;
            for (int i = 1; i <= 12; i++)
            {
                ledgerCopy.Bill[i] = Bill[i];
                ledgerCopy.Amt[i] = Amt[i];
                ledgerCopy.Date[i] = Date[i];
                ledgerCopy.Bal[i] = Bal[i];
            }

            return ledgerCopy;
        }

        //public string GetPropertyValue(string propertyName)
        //{
        //    return GetType().GetProperties()
        //       .Single(pi => pi.Name == propertyName)
        //       .GetValue(this, null).ToString();
        //}

        //public void SetPropertyValue(string propertyName, object value)
        //{
        //    GetType().GetProperties()
        //       .Single(pi => pi.Name == propertyName).SetValue(this, value);
        //}

        public string GetLedgerTableNameForYear(CompanyTable companyTable)
        {
            //string ledgerName = string.Empty;
            string companyNameAndYear = companyTable.CompanyName + "_" + companyTable.FinancialYear;
            //ledgerName = companyNameConst + companyNameForYear + "_" + year;
            return (string.IsNullOrWhiteSpace(companyNameAndYear) ? string.Empty : companyNameConst + companyNameAndYear);
        }

        public void SetCompany(CompanyTable companyTable)
        {
            _companyTable = companyTable;
            TableName = GetLedgerTableNameForYear(_companyTable);
        }

        private string GetCompanyNameForYear(int year)
        {
            string companyName = string.Empty;
            CompanyTable ct = new CompanyTable();
            ct = ct.GetCompanyForYear(year);
            if (ct != null)
                companyName = ct.CompanyName;
            return companyName;
        }
        

        public DataTable GetAll()
        {
            if (!string.IsNullOrWhiteSpace(TableName))
            {
                string selectQuery = "select * from " + TableName;
                string query = string.Format(selectQuery);
                try
                {
                    ledgerDataSet = SelectObject(query, out ledgerAdapter);
                    cachedDataTable = ledgerDataSet.Tables[0];
                }
                catch
                {
                    throw;
                }

                return cachedDataTable;
            }
            else
            {
                return null;
            }
        }

        public bool IsDataSetValid()
        {
            return ledgerDataSet != null && ledgerDataSet.Tables.Count > 0;
        }

        public DataSet GetAllInDataSet(string tableName)
        {
            string selectQuery = "select * from " + tableName;
            DataSet dataSet = null;
            string query = string.Format(selectQuery);
            try
            {
                dataSet = SelectDataSet(query);
            }
            catch
            {
                throw;
            }

            return dataSet;
        }

        public void GetCustomerLedger(int custId, bool useCache = true)
        {
            InitLedgerToDefaultValues();
            if (useCache)
            {
                if (cachedDataTable == null)
                {
                    GetAll();
                }
                if (cachedDataTable != null)
                {
                    DataRow[] rows = cachedDataTable.Select("CustID = " + custId);
                    if (rows != null && rows.Length > 0)
                    {
                        InitLedgerObj(rows[0]);
                    }
                }
            }
            else
            {
                string selectQuery = string.Format("select * from {0} where CustID = {1}", TableName, custId);
                try
                {
                    DataTable dt = SelectObject(selectQuery);
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        InitLedgerObj(dt.Rows[0]);
                    }
                }
                catch
                {
                    throw;
                }
            }
        }

        public int GetPaymentFreqAmt()
        {
            int monthlyAmt = 0;
            CustomerDetailsTable customer = db.CustomerDetailsTables.SingleOrDefault(c => c.ID == CustID);
            if(customer != null)
            {
                monthlyAmt = customer.BillingCategoryTable.Amount / customer.BillingCategoryTable.Frequency;
            }
            return monthlyAmt;
        }

        public void InitLedgerObj(DataRow row)
        {
            InitLedgerToDefaultValues();
            if (row != null)
            {
                int id = 0;
                int.TryParse(row["ID"].ToString(), out id);
                ID = id;
                int custId = 0;
                int.TryParse(row["CustID"].ToString(), out custId);
                CustID = custId;
                CustCode = Convert.ToInt32(row["CustCode"].ToString());
                AreaCode = Convert.ToInt32(row["AreaCode"].ToString());
                AgentCode = row["AgentCode"].ToString();
                OldBalance = Convert.ToInt32(row["OldBalance"].ToString());
                OldBalancePaymentDetails = row["OldBalancePaymentDetails"].ToString();
                NumOfMonthsBal = Convert.ToInt32(row["NumOfMonthsBal"].ToString());
                TotalBalance = Convert.ToInt32(row["TotalBalance"].ToString());
                TotalAmtPaid = Convert.ToInt32(row["TotalAmtPaid"].ToString());

                for (int i = 1; i <= 12; i++)
                {
                    Bill[i] = row["Bill_" + i].ToString();
                    Amt[i] = row["Amt_" + i].ToString();
                    Date[i] = row["Date_" + i].ToString();
                    Bal[i] = row["Bal_" + i].ToString();
                }               
            }
        }
        
        public void InitLedgerToDefaultValues()
        {
            ID = 0;
            CustID = 0;
            CustCode = 0;
            AreaCode = 0;
            AgentCode = string.Empty;
            OldBalance = 0;
            OldBalancePaymentDetails = string.Empty;
            NumOfMonthsBal = 0;
            TotalBalance = 0;
            TotalAmtPaid = 0;            
            Bill = new BillNumberClass();
            Amt = new AmountClass();
            Date = new DateClass();
            Bal = new BalanceClass();
        }        

        public int GetCustomerTotalBalance(int cutId)
        {
            int totalBalance = 0;
            try {
                if (ledgerDataSet.Tables[0] != null && ledgerDataSet.Tables[0].Rows.Count > 0)
                {
                    DataRow[] resultRows = ledgerDataSet.Tables[0].Select("CustID=" + cutId);
                    if (resultRows != null && resultRows.Length > 0)
                    {
                        string tmpStr = resultRows[0]["TotalBalance"].ToString();
                        int.TryParse(tmpStr, out totalBalance);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return totalBalance;
        }

        public void UpdateDataSet()
        {
            ledgerAdapter.Update(ledgerDataSet);
        }

        public bool InsertLedgerEntry()
        {
            try
            {
                string query = string.Format("insert into " + TableName + " (CustID," +
                                                                                    "CustCode," +
                                                                                    "AreaCode," +
                                                                                    "AgentCode," +
                                                                                    "OldBalance," +
                                                                                    "NumOfMonthsBal," +
                                                                                    "TotalBalance," +
                                                                                    "TotalAmtPaid," +
                                                                                    "Bill_1," +
                                                                                    "Bill_2," +
                                                                                    "Bill_3," +
                                                                                    "Bill_4," +
                                                                                    "Bill_5," +
                                                                                    "Bill_6," +
                                                                                    "Bill_7," +
                                                                                    "Bill_8," +
                                                                                    "Bill_9," +
                                                                                    "Bill_10," +
                                                                                    "Bill_11," +
                                                                                    "Bill_12," +
                                                                                    "Bal_1," +
                                                                                    "Bal_2," +
                                                                                    "Bal_3," +
                                                                                    "Bal_4," +
                                                                                    "Bal_5," +
                                                                                    "Bal_6," +
                                                                                    "Bal_7," +
                                                                                    "Bal_8," +
                                                                                    "Bal_9," +
                                                                                    "Bal_10," +
                                                                                    "Bal_11," +
                                                                                    "Bal_12)" +
                                                                                    " values({0},{1},{2},'{3}',{4},{5},{6},{7}," +
                                                                                    "'{8}','{9}','{10}','{11}','{12}','{13}','{14}','{15}','{16}','{17}','{18}','{19}'," +
                                                                                    "'{20}','{21}','{22}','{23}','{24}','{25}','{26}','{27}','{28}','{29}','{30}','{31}'" +
                                                                                    ")", CustID, CustCode, AreaCode, AgentCode, OldBalance, NumOfMonthsBal, TotalBalance, TotalAmtPaid,
                                                                                    Bill[1].Trim(), Bill[2].Trim(), Bill[3].Trim(), Bill[4].Trim(), Bill[5].Trim(), Bill[6].Trim(), Bill[7].Trim(), Bill[8].Trim(), Bill[9].Trim(), Bill[10].Trim(), Bill[11].Trim(), Bill[12].Trim(),
                                                                                    Bal[1].Trim(), Bal[2].Trim(), Bal[3].Trim(), Bal[4].Trim(), Bal[5].Trim(), Bal[6].Trim(), Bal[7].Trim(), Bal[8].Trim(), Bal[9].Trim(), Bal[10].Trim(), Bal[11].Trim(), Bal[12].Trim()
                                                                                    );
            return ExecuteNonQuery(query);
            }
            catch
            {
                throw;
            }
        }

        public bool UpdateLedgerRow(DataRow row)
        {
            row["ID"] = ID.ToString();
            row["CustID"] = CustID.ToString();
            row["CustCode"] = CustCode.ToString();
            row["AreaCode"] = AreaCode.ToString();
            row["AgentCode"] = AgentCode.ToString();
            row["OldBalance"] = OldBalance.ToString();
            row["OldBalancePaymentDetails"] = OldBalancePaymentDetails.ToString();
            row["NumOfMonthsBal"] = NumOfMonthsBal.ToString();
            row["TotalBalance"] = TotalBalance.ToString();
            row["TotalAmtPaid"] = TotalAmtPaid.ToString();

            for (int i = 1; i <= 12; i++)
            {
                row["Bill_" + i] = Bill[i].ToString();
                row["Amt_" + i] = Amt[i].ToString();
                row["Date_" + i] = Date[i].ToString();
                row["Bal_" + i] = Bal[i].ToString();
            }
            return Update();
        }

        public bool Update()
        {
            try {
                string query = string.Format("UPDATE {0} " +
                      "SET [CustID] = " + CustID +
                      ",[CustCode] = " + CustCode +
                      ",[AreaCode] = " + AreaCode +
                      ",[AgentCode] = '" + AgentCode + "'" +
                      ",[OldBalance] = " + OldBalance +
                      ",[OldBalancePaymentDetails] = '" + OldBalancePaymentDetails + "'" +
                      ",[NumOfMonthsBal] = " + NumOfMonthsBal +
                      ",[TotalBalance] = " + TotalBalance +
                      ",[TotalAmtPaid] = " + TotalAmtPaid +
                      ",[Bill_1] = '" + Bill[1] + "'" +
                      ",[Bill_2] = '" + Bill[2] + "'" +
                      ",[Bill_3] = '" + Bill[3] + "'" +
                      ",[Bill_4] = '" + Bill[4] + "'" +
                      ",[Bill_5] = '" + Bill[5] + "'" +
                      ",[Bill_6] = '" + Bill[6] + "'" +
                      ",[Bill_7] = '" + Bill[7] + "'" +
                      ",[Bill_8] = '" + Bill[8] + "'" +
                      ",[Bill_9] = '" + Bill[9] + "'" +
                      ",[Bill_10] = '" + Bill[10] + "'" +
                      ",[Bill_11] = '" + Bill[11] + "'" +
                      ",[Bill_12] = '" + Bill[12] + "'" +
                      ",[Amt_1] = '" + Amt[1] + "'" +
                      ",[Amt_2] = '" + Amt[2] + "'" +
                      ",[Amt_3] = '" + Amt[3] + "'" +
                      ",[Amt_4] = '" + Amt[4] + "'" +
                      ",[Amt_5] = '" + Amt[5] + "'" +
                      ",[Amt_6] = '" + Amt[6] + "'" +
                      ",[Amt_7] = '" + Amt[7] + "'" +
                      ",[Amt_8] = '" + Amt[8] + "'" +
                      ",[Amt_9] = '" + Amt[9] + "'" +
                      ",[Amt_10] = '" + Amt[10] + "'" +
                      ",[Amt_11] = '" + Amt[11] + "'" +
                      ",[Amt_12] = '" + Amt[12] + "'" +
                      ",[Date_1] = '" + Date[1] + "'" +
                      ",[Date_2] = '" + Date[2] + "'" +
                      ",[Date_3] = '" + Date[3] + "'" +
                      ",[Date_4] = '" + Date[4] + "'" +
                      ",[Date_5] = '" + Date[5] + "'" +
                      ",[Date_6] = '" + Date[6] + "'" +
                      ",[Date_7] = '" + Date[7] + "'" +
                      ",[Date_8] = '" + Date[8] + "'" +
                      ",[Date_9] = '" + Date[9] + "'" +
                      ",[Date_10] = '" + Date[10] + "'" +
                      ",[Date_11] = '" + Date[11] + "'" +
                      ",[Date_12] = '" + Date[12] + "'" +
                      ",[Bal_1] = '" + Bal[1] + "'" +
                      ",[Bal_2] = '" + Bal[2] + "'" +
                      ",[Bal_3] = '" + Bal[3] + "'" +
                      ",[Bal_4] = '" + Bal[4] + "'" +
                      ",[Bal_5] = '" + Bal[5] + "'" +
                      ",[Bal_6] = '" + Bal[6] + "'" +
                      ",[Bal_7] = '" + Bal[7] + "'" +
                      ",[Bal_8] = '" + Bal[8] + "'" +
                      ",[Bal_9] = '" + Bal[9] + "'" +
                      ",[Bal_10] = '" + Bal[10] + "'" +
                      ",[Bal_11] = '" + Bal[11] + "'" +
                      ",[Bal_12] = '" + Bal[12] + "'" +
                      " where ID = " + ID, TableName);
                return ExecuteNonQuery(query);
            }
            catch
            {
                throw;
            }
        }

        public bool CreateLedgerTable(CompanyTable companyTable)
        {
            TableName = CompanyNamePrefix + companyTable.CompanyName + "_" + companyTable.FinancialYear;

            string newQuery = "CREATE TABLE dbo." + TableName + "(ID int IDENTITY(1,1) NOT NULL," +
                                                                    "CustID int NOT NULL," +
                                                                    "CustCode int NOT NULL," +
                                                                    "AreaCode int NOT NULL," +
                                                                    "AgentCode varchar(50) NOT NULL," +
                                                                    "OldBalance int NOT NULL DEFAULT ((0))," +
                                                                    "OldBalancePaymentDetails varchar(Max) NULL DEFAULT ('')," +
                                                                    "NumOfMonthsBal int NOT NULL," +
                                                                    "TotalBalance int NOT NULL," +
                                                                    "TotalAmtPaid int NOT NULL," +
                                                                    "Bill_1 varchar(50) NOT NULL DEFAULT ('-1')," +
                                                                    "Bill_2 varchar(50) NOT NULL DEFAULT ('-1')," +
                                                                    "Bill_3 varchar(50) NOT NULL DEFAULT ('-1')," +
                                                                    "Bill_4 varchar(50) NOT NULL DEFAULT ('-1')," +
                                                                    "Bill_5 varchar(50) NOT NULL DEFAULT ('-1')," +
                                                                    "Bill_6 varchar(50) NOT NULL DEFAULT ('-1')," +
                                                                    "Bill_7 varchar(50) NOT NULL DEFAULT ('-1')," +
                                                                    "Bill_8 varchar(50) NOT NULL DEFAULT ('-1')," +
                                                                    "Bill_9 varchar(50) NOT NULL DEFAULT ('-1')," +
                                                                    "Bill_10 varchar(50) NOT NULL DEFAULT ('-1')," +
                                                                    "Bill_11 varchar(50) NOT NULL DEFAULT ('-1')," +
                                                                    "Bill_12 varchar(50) NOT NULL DEFAULT ('-1')," +
                                                                    "Amt_1 varchar(100) NULL DEFAULT ('')," +
                                                                    "Amt_2 varchar(100) NULL DEFAULT ('')," +
                                                                    "Amt_3 varchar(100) NULL DEFAULT ('')," +
                                                                    "Amt_4 varchar(100) NULL DEFAULT ('')," +
                                                                    "Amt_5 varchar(100) NULL DEFAULT ('')," +
                                                                    "Amt_6 varchar(100) NULL DEFAULT ('')," +
                                                                    "Amt_7 varchar(100) NULL DEFAULT ('')," +
                                                                    "Amt_8 varchar(100) NULL DEFAULT ('')," +
                                                                    "Amt_9 varchar(100) NULL DEFAULT ('')," +
                                                                    "Amt_10 varchar(100) NULL DEFAULT ('')," +
                                                                    "Amt_11 varchar(100) NULL DEFAULT ('')," +
                                                                    "Amt_12 varchar(100) NULL DEFAULT ('')," +
                                                                    "Date_1 varchar(100) NULL DEFAULT ('')," +
                                                                    "Date_2 varchar(100) NULL DEFAULT ('')," +
                                                                    "Date_3 varchar(100) NULL DEFAULT ('')," +
                                                                    "Date_4 varchar(100) NULL DEFAULT ('')," +
                                                                    "Date_5 varchar(100) NULL DEFAULT ('')," +
                                                                    "Date_6 varchar(100) NULL DEFAULT ('')," +
                                                                    "Date_7 varchar(100) NULL DEFAULT ('')," +
                                                                    "Date_8 varchar(100) NULL DEFAULT ('')," +
                                                                    "Date_9 varchar(100) NULL DEFAULT ('')," +
                                                                    "Date_10 varchar(100) NULL DEFAULT ('')," +
                                                                    "Date_11 varchar(100) NULL DEFAULT ('')," +
                                                                    "Date_12 varchar(100) NULL DEFAULT ('')," +
                                                                    "Bal_1 varchar(100) NULL DEFAULT ('')," +
                                                                    "Bal_2 varchar(100) NULL DEFAULT ('')," +
                                                                    "Bal_3 varchar(100) NULL DEFAULT ('')," +
                                                                    "Bal_4 varchar(100) NULL DEFAULT ('')," +
                                                                    "Bal_5 varchar(100) NULL DEFAULT ('')," +
                                                                    "Bal_6 varchar(100) NULL DEFAULT ('')," +
                                                                    "Bal_7 varchar(100) NULL DEFAULT ('')," +
                                                                    "Bal_8 varchar(100) NULL DEFAULT ('')," +
                                                                    "Bal_9 varchar(100) NULL DEFAULT ('')," +
                                                                    "Bal_10 varchar(100) NULL DEFAULT ('')," +
                                                                    "Bal_11 varchar(100) NULL DEFAULT ('')," +
                                                                    "Bal_12 varchar(100) NULL DEFAULT ('')," +
                                                                    "PRIMARY KEY (CustID)," +
                                                                    "FOREIGN KEY(AgentCode) REFERENCES AgentDetailsTable (AgentCode)," +
                                                                    "FOREIGN KEY(AreaCode) REFERENCES AreaDetailsTable (AreaCode)," +
                                                                    "FOREIGN KEY(CustID) REFERENCES CustomerDetailsTable (ID) ON UPDATE CASCADE ON DELETE CASCADE)";
            return ExecuteNonQuery(newQuery);
        }
    }
}