using ActvMvcClient.LedgerImport;
using ActvMvcClient.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;

namespace ActvMvcClient.DynamicTableModels
{
    public class LedgerOps
    {
        private ActvMvcClientEntities db = new ActvMvcClientEntities();


        public IList<LedgerTable> RemoveDuplicateMobileEntries(CompanyTable Company)
        {
            List<LedgerTable> duplicateList = new List<LedgerTable>();
            Dictionary<string, DataTable> ledgerTables = new Dictionary<string, DataTable>();
            //Build the years for ledger table
            if (Company != null)
            {
                List<int> years = new List<int>();
                List<CompanyTable> companiesList = db.CompanyTables.Where(c => c.CompanyId == Company.CompanyId).ToList();
                if (companiesList != null)
                {
                    foreach (CompanyTable ct in companiesList)
                    {
                        int ledgerYear = int.Parse(ct.FinancialYear);
                        years.Add(ledgerYear);
                    }
                }
                years.Sort();
                List<MobileCollection> mobileCollectionList = db.MobileCollections.ToList();
                string customerListStr = string.Empty;
                LedgerTable ledger = new LedgerTable(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                //Iterate throgh the duplicate entries. For each each item, find the entry in ledger tables.
                foreach (MobileCollection mobileCollection in mobileCollectionList)
                {
                    string duplicateActvTransactDate = mobileCollection.CollectionDate.ToString("dd/MM/yyyy");
                    int balanceAdditionForNextYear = 0;
                    int oldBalanceUpdate = 0;
                    foreach (int lYear in years)
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

        //private void UpdateLedger(LedgerTable customerLedger)
        //{
        //    string query =
        //        string.Format(
        //            "update {0} set OldBalance = {1},TotalBalance = {2},TotalAmtPaid = {3},Bill_1 = '{4}',Bill_2 = '{5}',Bill_3 = '{6}',Bill_4 = '{7}',Bill_5 = '{8}',Bill_6 = '{9}',Bill_7 = '{10}',Bill_8 = '{11}',Bill_9 = '{12}',Bill_10 = '{13}',Bill_11 = '{14}',Bill_12 = '{15}',Amt_1 = '{16}',Amt_2 = '{17}',Amt_3 = '{18}',Amt_4 = '{19}',Amt_5 = '{20}',Amt_6 = '{21}',Amt_7 = '{22}',Amt_8 = '{23}',Amt_9 = '{24}',Amt_10 = '{25}',Amt_11 = '{26}',Amt_12 = '{27}',Date_1 = '{28}',Date_2 = '{29}',Date_3 = '{30}',Date_4 = '{31}',Date_5 = '{32}',Date_6 = '{33}',Date_7 = '{34}',Date_8 = '{35}',Date_9 = '{36}',Date_10 = '{37}',Date_11 = '{38}',Date_12 = '{39}',Bal_1 = '{40}',Bal_2 = '{41}',Bal_3 = '{42}',Bal_4 = '{43}',Bal_5 = '{44}',Bal_6 = '{45}',Bal_7 = '{46}',Bal_8 = '{47}',Bal_9 = '{48}',Bal_10 = '{49}',Bal_11 = '{50}',Bal_12 = '{51}' where CustID={52}",
        //                    customerLedger.TableName, customerLedger.OldBalance, customerLedger.TotalBalance,
        //                    customerLedger.TotalAmtPaid, customerLedger.Bill[1], customerLedger.Bill[2],
        //                    customerLedger.Bill[3], customerLedger.Bill[4], customerLedger.Bill[5],
        //                    customerLedger.Bill[6], customerLedger.Bill[7], customerLedger.Bill[8],
        //                    customerLedger.Bill[9], customerLedger.Bill[10], customerLedger.Bill[11],
        //                    customerLedger.Bill[12],
        //                    customerLedger.Amt[1], customerLedger.Amt[2], customerLedger.Amt[3],
        //                    customerLedger.Amt[4], customerLedger.Amt[5], customerLedger.Amt[6],
        //                    customerLedger.Amt[7], customerLedger.Amt[8], customerLedger.Amt[9],
        //                    customerLedger.Amt[10], customerLedger.Amt[11], customerLedger.Amt[12],
        //                    customerLedger.Date[1], customerLedger.Date[2],
        //                    customerLedger.Date[3], customerLedger.Date[4],
        //                    customerLedger.Date[5], customerLedger.Date[6],
        //                    customerLedger.Date[7], customerLedger.Date[8],
        //                    customerLedger.Date[9], customerLedger.Date[10],
        //                    customerLedger.Date[11], customerLedger.Date[12],
        //                    customerLedger.Bal[1], customerLedger.Bal[2],
        //                    customerLedger.Bal[3], customerLedger.Bal[4],
        //                    customerLedger.Bal[5], customerLedger.Bal[6],
        //                    customerLedger.Bal[7], customerLedger.Bal[8],
        //                    customerLedger.Bal[9], customerLedger.Bal[10],
        //                    customerLedger.Bal[11], customerLedger.Bal[12], customerLedger.CustID
        //                );
        //    customerLedger.ExecuteNonQuery(query);
        //}

       public int BeginUpdateLedger(int custId, int amount, CompanyTable companyYear, DateTime billDate, int billNum)
        {
            int oldBal = 0;
            return UpdateLedger(custId, amount, companyYear, billDate, billNum, out oldBal);
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
    }
}