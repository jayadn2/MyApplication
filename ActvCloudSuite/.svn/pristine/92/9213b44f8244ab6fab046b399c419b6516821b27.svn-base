using ActvWebApi.HelperClasses;
using ActvWebApi.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;

namespace ActvWebApi.DynamicTableModels
{
    public class LedgerOps
    {
        private ActvEntities db = new ActvEntities();
        private List<CompanyTable> companiesList = null;
        private List<int> companyYears = null;
        //Caching the Data tables from DB to improve the performance
        private Dictionary<string, DataTable> ledgerTablesCache = new Dictionary<string, DataTable>();

        private void BuildCompanyList(int currentYear)
        {
            if (companyYears == null && companiesList == null)
            {
                CompanyTable company = db.CompanyTables.FirstOrDefault(c => c.FinancialYear == currentYear.ToString());
                if (company != null)
                {
                    companyYears = new List<int>();
                    companiesList = db.CompanyTables.Where(c => c.CompanyId == company.CompanyId).ToList();
                    if (companiesList != null)
                    {
                        foreach (CompanyTable ct in companiesList)
                        {
                            int ledgerYear = int.Parse(ct.FinancialYear);
                            companyYears.Add(ledgerYear);
                        }
                    }
                    companyYears.Sort();
                }
                else
                {
                    companiesList = null;
                }
            }
        }

        public LedgerResponseModel GetLedger(int custId, CompanyTable company)
        {
            LedgerTable ledger = new LedgerTable(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            ledger.SetCompany(company);
            ledger.GetCustomerLedger(custId, useCache: false);
            string customerName;
            string areaName;
            int empId;
            string empName;
            LedgerResponseModel ledgerRespnseModel = null;//LedgerResponseModel.GetLedgerResponseModelObject(ledger,;
            return ledgerRespnseModel;
        } 

        public IList<LedgerTable> RemoveDuplicateMobileEntries(CompanyTable Company)
        {
            List<LedgerTable> duplicateList = new List<LedgerTable>();
            Dictionary<string, DataTable> ledgerTables = new Dictionary<string, DataTable>();
            //Build the years for ledger table
            int companyYear = int.Parse(Company.FinancialYear);
            BuildCompanyList(companyYear);
            if (Company != null)
            {                
                List<MobileCollection> mobileCollectionList = db.MobileCollections.ToList();
                string customerListStr = string.Empty;
                LedgerTable ledger = new LedgerTable(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                //Iterate throgh the duplicate entries. For each each item, find the entry in ledger tables.
                foreach (MobileCollection mobileCollection in mobileCollectionList)
                {
                    string duplicateActvTransactDate =
                        mobileCollection.CollectionDate.ToString("dd/MM/yyyy");
                    int balanceAdditionForNextYear = 0;
                    int oldBalanceUpdate = 0;
                    foreach (int lYear in companyYears)
                    {
                        oldBalanceUpdate = balanceAdditionForNextYear;
                        balanceAdditionForNextYear = 0;
                        CompanyTable companyTbl = companiesList.SingleOrDefault(c => c.FinancialYear == lYear.ToString());
                        ledger.SetCompany(companyTbl);
                        string tableName = ledger.TableName;
                        //Check if the table exists in the dictionary
                        DataTable ledgerDt = null;
                        if (!ledgerTables.TryGetValue(tableName, out ledgerDt))
                        {
                            ledgerDt = ledger.GetAll();
                            ledgerTables.Add(tableName, ledgerDt);
                        }
                        if (ledgerDt != null)
                        {
                            //where ReceiptNo like in Bill_1 to Bill_12 and Date like in Date_1 to Date_12
                            //  string query = string.Format("select * from {0} where " +
                            //"(Bill_1 LIKE '%{1}%') OR " +
                            //"(Bill_2 LIKE '%{1}%') OR " +
                            //"(Bill_3 LIKE '%{1}%') OR " +
                            //"(Bill_4 LIKE '%{1}%') OR " +
                            //"(Bill_5 LIKE '%{1}%') OR " +
                            //"(Bill_6 LIKE '%{1}%') OR " +
                            //"(Bill_7 LIKE '%{1}%') OR " +
                            //"(Bill_8 LIKE '%{1}%') OR " +
                            //"(Bill_9 LIKE '%{1}%') OR " +
                            //"(Bill_10 LIKE '%{1}%') OR " +
                            //"(Bill_11 LIKE '%{1}%') OR " +
                            //"(Bill_12 LIKE '%{1}%')", tableName, mobileCollection.RecieptNo);
                            string query = string.Format("(Bill_1 LIKE '%{0}%' AND Date_1 LIKE '%{1}%') OR " +
                           "(Bill_2 LIKE '%{0}%' AND Date_2 LIKE '%{1}%') OR " +
                           "(Bill_3 LIKE '%{0}%' AND Date_3 LIKE '%{1}%') OR " +
                           "(Bill_4 LIKE '%{0}%' AND Date_4 LIKE '%{1}%') OR " +
                           "(Bill_5 LIKE '%{0}%' AND Date_5 LIKE '%{1}%') OR " +
                           "(Bill_6 LIKE '%{0}%' AND Date_6 LIKE '%{1}%') OR " +
                           "(Bill_7 LIKE '%{0}%' AND Date_7 LIKE '%{1}%') OR " +
                           "(Bill_8 LIKE '%{0}%' AND Date_8 LIKE '%{1}%') OR " +
                           "(Bill_9 LIKE '%{0}%' AND Date_9 LIKE '%{1}%') OR " +
                           "(Bill_10 LIKE '%{0}%' AND Date_10 LIKE '%{1}%') OR " +
                           "(Bill_11 LIKE '%{0}%' AND Date_11 LIKE '%{1}%') OR " +
                           "(Bill_12 LIKE '%{0}%' AND Date_12 LIKE '%{1}%')", mobileCollection.RecieptNo, HelperClass.ConvertDateToInsertFormat(mobileCollection.CollectionDate));
                            DataRow[] filteredRows = ledgerDt.Select(query);
                            if (filteredRows != null && filteredRows.Length > 0)
                            {
                                foreach (DataRow row in filteredRows)
                                {
                                    ledger.InitLedgerObj(row);
                                    for (int i = 1; i < 13; i++)
                                    {
                                        string billNos = row["Bill_" + i.ToString()].ToString().Trim();
                                        string[] billNosArr = billNos.Split('-');
                                        string[] dateArr = new string[billNosArr.Length];
                                        string[] amountArr = new string[billNosArr.Length];
                                        string dateNo = row["Date_" + i.ToString()].ToString().Trim();
                                        string amountStr = row["Amt_" + i.ToString()].ToString();
                                        int monthBalance = 0;
                                        int.TryParse(row["Bal_" + i.ToString()].ToString(), out monthBalance);
                                        amountArr = amountStr.Split('-');

                                        string billNos_Modified = string.Empty;
                                        string dateNo_Modified = string.Empty;
                                        string amountStr_Modified = string.Empty;

                                        int numOfEntries = billNos.Split('-').Length;

                                        if (!string.IsNullOrEmpty(dateNo)) //dateNo will be null when bill num. = na or np
                                        {
                                            if (numOfEntries > 1) //If multiple entries are there for same month.
                                            {
                                                dateNo = dateNo.Replace('/', '-'); //Replace all the / with - for uniformaty
                                                string[] splitDateTmp = dateNo.Split('-');
                                                //For ex: '06-10-2013 - 06-11-2013' 
                                                //0 1 2, 3 4 5
                                                //0+0, 0+1, 0+2, 1+ 2, 1+3, 1+4, 2+ 4, 2+5, 2+6
                                                int sequence = 0;
                                                for (int a = 0; a < numOfEntries; a++)
                                                {
                                                    //If some cases, after - there is no value
                                                    if (splitDateTmp.Length > (a + sequence + 2))
                                                    {
                                                        dateArr[a] = splitDateTmp[a + sequence++].Trim() + "/" + splitDateTmp[a + sequence++].Trim() + "/" + splitDateTmp[a + sequence].Trim();
                                                    }
                                                    else
                                                    {
                                                        dateArr[a] = string.Empty;
                                                    }
                                                }

                                            }
                                            else //If it is a single date
                                            {
                                                dateArr[0] = dateNo.Replace('-', '/');
                                            }

                                            for (int j = 0; j < billNosArr.Length; j++) //For ex: 867 - 9607
                                            {

                                                string billNo = billNosArr[j];
                                                int billNoInt = 0; //
                                                int.TryParse(billNo.Trim(), out billNoInt);
                                                if (mobileCollection.RecieptNo == billNoInt && HelperClass.CompareDateStrings(duplicateActvTransactDate, dateArr[j]))
                                                {
                                                    if (mobileCollection.CustomerId != ledger.CustID)
                                                    {
                                                        //If the entry is made in other customer, simply delete the entry, adjust the amount and date and update the current year balance and next year balance
                                                        //For ex: Bill_11 =38 - 308 and 308 is the wrong entry, remove 308 and corresponding date and amount
                                                        //Add the amount to the total balance and deduct amount from total paid
                                                        ledger.DuplicateBillNumber = billNoInt.ToString();
                                                        ledger.DuplicateBillDate = duplicateActvTransactDate;
                                                        ledger.DuplicateBillMonth = i;

                                                        duplicateList.Add(ledger.CreateCopy());
                                                        int index;
                                                        string modBill = ledger.Bill[i];
                                                        ledger.Bill[i] = HelperClass.RemoveDuplicateEntryFromLedgerEntry(mobileCollection.RecieptNo.ToString(), modBill, out index);
                                                        string modDate = ledger.Date[i];
                                                        string removedEntry = string.Empty;
                                                        ledger.Date[i] = HelperClass.RemoveDuplicateEntryFromLedgerEntryOnIndex(modDate, index, out removedEntry, true);
                                                        string modAmt = ledger.Amt[i];
                                                        ledger.Amt[i] = HelperClass.RemoveDuplicateEntryFromLedgerEntryOnIndex(modAmt, index, out removedEntry);
                                                        ledger.DuplicateBillAmt = removedEntry;
                                                        int amt = 0;
                                                        int.TryParse(removedEntry, out amt);
                                                        int bal = 0;
                                                        int.TryParse(ledger.Bal[i], out bal);
                                                        bal += amt;
                                                        ledger.Bal[i] = bal.ToString();
                                                        ledger.UpdateLedgerRow(row);
                                                        //Update the current year, next year balance
                                                        UpdateTotalBalanceForCustomer(ledger);

                                                    }
                                                }

                                            }
                                        }

                                    }

                                }
                            }
                        }
                    }
                }
            }
            return duplicateList;
        }

        public void UpdateTotalBalanceForCustomer(LedgerTable customerLedger)
        {
            if (customerLedger != null)
            {
                int monthlyBalance = 0;
                for (int i = 1; i < 13; i++)
                {
                    int tmpBal = 0;
                    int.TryParse(customerLedger.Bal[i], out tmpBal);
                    monthlyBalance += tmpBal;
                }
                customerLedger.TotalBalance = monthlyBalance + customerLedger.OldBalance;
                customerLedger.Update();

                CompanyTable nextYearCompany = NextYearLedgerExists(customerLedger.Company);
                if (nextYearCompany != null)
                {
                    //Update old balance for next year (if it exists) with current year total balance.
                    LedgerTable nextYearCustomerLedger = new LedgerTable(customerLedger.ConnectionString);
                    nextYearCustomerLedger.SetCompany(nextYearCompany);
                    nextYearCustomerLedger.GetCustomerLedger(customerLedger.CustID, useCache: false);
                    //Update the old balance from current year total balance.
                    nextYearCustomerLedger.OldBalance = customerLedger.TotalBalance;
                    UpdateTotalBalanceForCustomer(nextYearCustomerLedger);
                }
                else
                {
                    return;
                }

            }
        }

        private CompanyTable NextYearLedgerExists(CompanyTable currentYearCompany)
        {
            CompanyTable result = null;
            int financeYear = 0;
            int.TryParse(currentYearCompany.FinancialYear, out financeYear);
            financeYear++;
            result = db.CompanyTables.SingleOrDefault(c => c.CompanyId == currentYearCompany.CompanyId && c.FinancialYear == financeYear.ToString());
            return result;
        }

        private CompanyTable PrevYearLedgerExists(CompanyTable currentYearCompany)
        {
            CompanyTable result = null;
            int financeYear = 0;
            int.TryParse(currentYearCompany.FinancialYear, out financeYear);
            financeYear--;
            result = db.CompanyTables.SingleOrDefault(c => c.CompanyId == currentYearCompany.CompanyId && c.FinancialYear == financeYear.ToString());
            return result;
        }        

       public int BeginUpdateLedger(int custId, int amount, CompanyTable companyYear, DateTime billDate, int billNum, int empId, string agentCode, string CollectionSource = "bb") //Default mode of entering is bb -> bill book
        {
           if(empId == -1) //If emp id is -1, we need to find it here.
           {
               CustomerDetailsTable customer = db.CustomerDetailsTables.SingleOrDefault(c => c.ID == custId);
               if (customer != null)
               {
                   empId = customer.AgentDetailsTable.EmpNum;
                   agentCode = customer.AgentCode;
               }
           }
            int oldBal = 0;
            int remAmt = UpdateLedger(custId, amount, companyYear, billDate, billNum, out oldBal);
            AmountCollectionTable act = new AmountCollectionTable();
            act.EmpID = empId;
            act.AgentCode = agentCode;
            act.CustomerID = custId;
            act.CollectionAmount = amount;
            act.BillNum = billNum;
            act.BillBookNum = 0;
            act.CollectionDate = HelperClass.ConvertDateToInsertFormat(billDate);
            act.CollectionSource = CollectionSource;
            act.CollectionDate2 = billDate;
            db.AmountCollectionTables.Add(act);
            db.SaveChanges();
            return remAmt;
        }

        public int UpdateLedger(int custId, int amount, CompanyTable companyYear, DateTime billDate, int billNum, out int oldBalance)
        {            
            if (amount > 0 && companyYear != null)
            {
                int remAmount = amount;
                LedgerTable customerLedger = new LedgerTable(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                customerLedger.SetCompany(companyYear);
                customerLedger.GetCustomerLedger(custId);
                //oldBalance = customerLedger.OldBalance;
                if (customerLedger.OldBalance > 0)
                {
                    CompanyTable prevYearCompany = PrevYearLedgerExists(companyYear);
                    if (prevYearCompany != null && amount > 0)
                    {
                        int oldBalanceRet = 0;
                        //If prev year ledger exists, enter the amount to prev year ledger
                        remAmount = UpdateLedger(custId, amount, prevYearCompany, billDate, billNum, out oldBalanceRet);
                        //Update current year ledger old balance with prev year ledger old balance
                        //If returned old balance is -1 means, we dont have prev. year old balance info.
                        if (oldBalanceRet != -1)
                        {
                            customerLedger.OldBalance = oldBalanceRet;
                        }
                    }
                    else
                    {
                        //If prev year ledger does not exists, make the entry in old payment details of current year ledger
                        //Check if the entered amount is greater, less or equal to old balance.
                        remAmount = amount - customerLedger.OldBalance;
                        //If entered amount is equal to old balance, make the oldbalance payment
                        int oldBalanceAmt = 0;
                        if (remAmount <= 0)
                        {
                            oldBalanceAmt = amount;
                            if (remAmount == 0)
                            {
                                customerLedger.OldBalance = 0;
                            }
                            else if(remAmount < 0)
                            {
                                customerLedger.OldBalance = customerLedger.OldBalance - amount;
                            }
                        }
                        else if(remAmount > 0)
                        {
                            oldBalanceAmt = customerLedger.OldBalance;
                            customerLedger.OldBalance = 0;
                        }
                        customerLedger.OldBalancePaymentDetails = "Bill No.:" + billNum + "/ Rs.:" + oldBalanceAmt + "/ Date:" + HelperClass.ConvertDateToInsertFormat(billDate);                        
                    }
                }

                //If remAmount is still >0, then continue update for current year.
                if (remAmount > 0)
                {
                    remAmount = LedgerEntry(customerLedger, remAmount, billDate, billNum);
                }                
                CalculateTotalBalance(customerLedger);
                CalculateTotalAmtPaid(customerLedger);
                customerLedger.Update();
                oldBalance = customerLedger.TotalBalance;
                return remAmount;
            }
            else
            {
                oldBalance = -1;
                return 0;
            }
        }

        private int LedgerEntry(LedgerTable customerLedger, int amount, DateTime billDate, int billNum)
        {
            int remAmount = amount;
            if (customerLedger != null && amount > 0)
            {
                int monthVar = 1;
                while ((remAmount > 0) && (monthVar < 13))
                {
                    //Check for each month balance and update the ledger
                    AllocateAmount(customerLedger, remAmount, billDate, billNum, monthVar++, out remAmount);
                }
                               
            }
            return remAmount;
        }

        private void AllocateAmount(LedgerTable customerLedger, int amount, DateTime billDate, int billNum, int month, out int remAmt)
        {
            int discount = 0;
            remAmt = amount;
            if (amount > 0 || discount > 0)
            {
                if (customerLedger.Bill[month] == "na")
                {
                    return;
                }
                int bal = 0;
                int.TryParse(customerLedger.Bal[month].Trim(), out bal);
                //If bal is 0 and "np" for the month, means not paid for the month. Get the 
                if (bal == 0 && customerLedger.Bill[month].ToLower().Trim() == "np")
                {
                    //Get the monthly balance
                    bal = customerLedger.GetPaymentFreqAmt();
                }
                if (bal > 0)
                {
                    remAmt = amount - bal;
                    customerLedger.Bill[month] = HelperClass.ConcatenateString(customerLedger.Bill[month], billNum.ToString()); //If already amount is present in the entry, concatenate
                    customerLedger.Date[month] = HelperClass.ConcatenateString(customerLedger.Date[month], HelperClass.ConvertDateToInsertFormat(billDate));
                    if (remAmt >= 0)
                    {
                        customerLedger.Bal[month] = "0";
                        customerLedger.Amt[month] = HelperClass.ConcatenateString(customerLedger.Amt[month], bal.ToString());
                    }
                    else
                    {
                        //rem amt is < 0 means, the balance is more than the amount paid, so still balance is there for current month.
                        int monthBal = remAmt * -1;
                        customerLedger.Bal[month] = monthBal.ToString();
                        customerLedger.Amt[month] = HelperClass.ConcatenateString(customerLedger.Amt[month], amount.ToString());
                        //Make remAmt 0, because  the balance is more than the amount paid
                        remAmt = 0;
                    }
                }                
            }
        }

        private void CalculateTotalBalance(LedgerTable custLedger)
        {
            int totalBalance = custLedger.OldBalance;
            for (int i = 1; i < 13; i++)
            {
                int bal = 0;
                int.TryParse(custLedger.Bal[i], out bal);
                totalBalance += bal;
            }
            custLedger.TotalBalance = totalBalance;
        }

        private void CalculateTotalAmtPaid(LedgerTable custLedger)
        {
            custLedger.TotalAmtPaid = 0;
            for (int i = 1; i < 13; i++)
            {
                string[] amtStrArr = custLedger.Amt[i].Split('-');
                if (amtStrArr != null)
                {
                    foreach (string amtStr in amtStrArr)
                    {
                        int amt = 0;
                        int.TryParse(amtStr.Trim(), out amt);
                        custLedger.TotalAmtPaid += amt;
                    }
                }
            }
            //If bal amt is negative, add that to total amt paid.
            if (custLedger.TotalBalance < 0)
            {
                int extraAmtPaid = custLedger.TotalBalance * -1;
                custLedger.TotalAmtPaid += extraAmtPaid;
            }
        }

        public void CheckDuplicateEntries(IList<LedgerEntry> entries, int companyYear)
        {
                        
            foreach (LedgerEntry entry in entries)
            {
                LedgerTable ledger = null;
                entry.IsDuplicateEntry = IsDuplicateEntry(entry.CustomerId, entry.BillDate, entry.BillNum, out ledger);
                entry.Ledger = ledger;
            }
        }

        public bool IsDuplicateEntry(LedgerEntry ledgerEntry)
        {
            LedgerTable ledger=null;
            ledgerEntry.IsDuplicateEntry = IsDuplicateEntry(ledgerEntry.CustomerId, ledgerEntry.BillDate, ledgerEntry.BillNum, out ledger);
            return ledgerEntry.IsDuplicateEntry;
        }

        public bool IsDuplicateEntry(int AccountNo, DateTime CollectionDate, int ReceiptNo)
        {
            LedgerTable ledger = null;
            return IsDuplicateEntry(AccountNo, CollectionDate, ReceiptNo, out ledger);
        }

        public bool IsDuplicateEntry(int AccountNo, DateTime CollectionDate, int ReceiptNo, out LedgerTable ledger)
        {
            BuildCompanyList(DateTime.Now.Year);
            ledger = new LedgerTable(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);

            string duplicateActvTransactDate = HelperClass.ConvertDateToInsertFormat(CollectionDate);
            int balanceAdditionForNextYear = 0;
            int oldBalanceUpdate = 0;
            foreach (int lYear in companyYears)
            {
                oldBalanceUpdate = balanceAdditionForNextYear;
                balanceAdditionForNextYear = 0;
                CompanyTable companyTbl = companiesList.SingleOrDefault(c => c.FinancialYear == lYear.ToString());
                ledger.SetCompany(companyTbl);
                string tableName = ledger.TableName;
                //Check if the table exists in the dictionary
                DataTable ledgerDt = null;
                if (!ledgerTablesCache.TryGetValue(tableName, out ledgerDt))
                {
                    ledgerDt = ledger.GetAll();
                    ledgerTablesCache.Add(tableName, ledgerDt);
                }
                if (ledgerDt != null)
                {
                    string query = string.Format("(Bill_1 LIKE '%{0}%' AND Date_1 LIKE '%{1}%') OR " +
                   "(Bill_2 LIKE '%{0}%' AND Date_2 LIKE '%{1}%') OR " +
                   "(Bill_3 LIKE '%{0}%' AND Date_3 LIKE '%{1}%') OR " +
                   "(Bill_4 LIKE '%{0}%' AND Date_4 LIKE '%{1}%') OR " +
                   "(Bill_5 LIKE '%{0}%' AND Date_5 LIKE '%{1}%') OR " +
                   "(Bill_6 LIKE '%{0}%' AND Date_6 LIKE '%{1}%') OR " +
                   "(Bill_7 LIKE '%{0}%' AND Date_7 LIKE '%{1}%') OR " +
                   "(Bill_8 LIKE '%{0}%' AND Date_8 LIKE '%{1}%') OR " +
                   "(Bill_9 LIKE '%{0}%' AND Date_9 LIKE '%{1}%') OR " +
                   "(Bill_10 LIKE '%{0}%' AND Date_10 LIKE '%{1}%') OR " +
                   "(Bill_11 LIKE '%{0}%' AND Date_11 LIKE '%{1}%') OR " +
                   "(Bill_12 LIKE '%{0}%' AND Date_12 LIKE '%{1}%')", ReceiptNo, HelperClass.ConvertDateToInsertFormat(CollectionDate));
                    DataRow[] filteredRows = ledgerDt.Select(query);
                    if (filteredRows != null && filteredRows.Length > 0)
                    {
                        foreach (DataRow row in filteredRows)
                        {
                            ledger.InitLedgerObj(row);
                            for (int i = 1; i < 13; i++)
                            {
                                string billNos = row["Bill_" + i.ToString()].ToString().Trim();
                                string[] billNosArr = billNos.Split('-');
                                string[] dateArr = new string[billNosArr.Length];
                                string[] amountArr = new string[billNosArr.Length];
                                string dateNo = row["Date_" + i.ToString()].ToString().Trim();
                                string amountStr = row["Amt_" + i.ToString()].ToString();
                                int monthBalance = 0;
                                int.TryParse(row["Bal_" + i.ToString()].ToString(), out monthBalance);
                                amountArr = amountStr.Split('-');

                                string billNos_Modified = string.Empty;
                                string dateNo_Modified = string.Empty;
                                string amountStr_Modified = string.Empty;

                                int numOfEntries = billNos.Split('-').Length;

                                if (!string.IsNullOrEmpty(dateNo)) //dateNo will be null when bill num. = na or np
                                {
                                    if (numOfEntries > 1) //If multiple entries are there for same month.
                                    {
                                        dateNo = dateNo.Replace('/', '-'); //Replace all the / with - for uniformaty
                                        string[] splitDateTmp = dateNo.Split('-');
                                        //For ex: '06-10-2013 - 06-11-2013' 
                                        //0 1 2, 3 4 5
                                        //0+0, 0+1, 0+2, 1+ 2, 1+3, 1+4, 2+ 4, 2+5, 2+6
                                        int sequence = 0;
                                        for (int a = 0; a < numOfEntries; a++)
                                        {
                                            //If some cases, after - there is no value
                                            if (splitDateTmp.Length > (a + sequence + 2))
                                            {
                                                dateArr[a] = splitDateTmp[a + sequence++].Trim() + "/" + splitDateTmp[a + sequence++].Trim() + "/" + splitDateTmp[a + sequence].Trim();
                                            }
                                            else
                                            {
                                                dateArr[a] = string.Empty;
                                            }
                                        }

                                    }
                                    else //If it is a single date
                                    {
                                        dateArr[0] = dateNo.Replace('-', '/');
                                    }

                                    for (int j = 0; j < billNosArr.Length; j++) //For ex: 867 - 9607
                                    {

                                        string billNo = billNosArr[j];
                                        int billNoInt = 0; //
                                        int.TryParse(billNo.Trim(), out billNoInt);
                                        if (ReceiptNo == billNoInt && HelperClass.CompareDateStrings(duplicateActvTransactDate, dateArr[j]))
                                        {
                                            return true;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return false;
        }
    }
}