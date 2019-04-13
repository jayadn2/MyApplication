using ActvMvcClient.DynamicTableModels;
using ActvMvcClient.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace ActvMvcClient.Controllers
{
    [Authorize]
    public class BalanceUpdateController : AsyncController
    {
        private LedgerTable ledger;
        private LedgerTable prevYearLedger;
        private ActvMvcClientEntities db = new ActvMvcClientEntities();
        private int currentYear;
        private int taskId = 23;
        private static int progressVar;
        private bool updateCompleted;

        public BalanceUpdateController()
        {
            //InitLedgerTableName(DateTime.Now.Year);
        }

        private void InitLedgerTableName(CompanyTable companyTable)
        {
            currentYear = Convert.ToInt32(companyTable.FinancialYear);
            ViewBag.CurrentYear = currentYear;
            ledger = new LedgerTable(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            ledger.TableName = ledger.GetLedgerTableNameForYear(companyTable);
            prevYearLedger = new LedgerTable(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            prevYearLedger.TableName = ledger.GetLedgerTableNameForYear(companyTable.GetPreviousYearCompany());
        }

        

        // GET: BalanceUpdate
        public ActionResult Index()
        {
            return IndexAction();
        }

        private ActionResult IndexAction()
        {
            updateCompleted = false;            
            db.CompanyDetailsCreateProcedure();
            CompanyTable currentYearCompany = db.CompanyTables.FirstOrDefault(c => c.FinancialYear == DateTime.Now.Year.ToString());
            InitLedgerTableName(currentYearCompany);
            ViewBag.Company = new SelectList(db.CompanyTables, "ID", "FinancialYear", currentYearCompany.ID);
            return View(db.CompanyTables);
        }

        [NoAsyncTimeout]
        [HttpPost]
        public ActionResult UpdateAsync(int? Company)
        {
            updateCompleted = false;
            if (Company != null)
            {
                CompanyTable selectedCompany = db.CompanyTables.FirstOrDefault(c => c.ID == Company.Value);
                if (selectedCompany != null)
                {
                    int finYear = 0;
                    if (int.TryParse(selectedCompany.FinancialYear, out finYear))
                    {
                        InitLedgerTableName(selectedCompany);
                        AsyncManager.OutstandingOperations.Increment();
                        Task.Factory.StartNew(() =>
                        {
                        //Report progress
                        HttpContext.Application["task" + taskId] = 0;
                            //If updating for current year, update till previous month, else if year not current, update till December.
                            if (finYear == DateTime.Now.Year)
                                BalanceUpdateTillPreviousMonth();
                            else
                                BalanceUpdateTillDecember();

                            var result = "Update Completed";
                            AsyncManager.OutstandingOperations.Decrement();
                            AsyncManager.Parameters["result"] = result;
                            updateCompleted = true;
                            return result;
                        });
                    }
                }
            }
            return View();
        }

        public ActionResult UpdateCompleted(string result)
        {
            if (updateCompleted)
                return View();
            else
                return RedirectToAction("Index");
        }

        public ActionResult UpdateProgress()
        {
            //Report progress
            HttpContext.Application["task" + taskId] = progressVar;
            return Json(new
            {
                Progress = HttpContext.Application["task" + taskId].ToString()
            }, JsonRequestBehavior.AllowGet);
        }

        private void BalanceUpdateTillMonth(int endMonth)
        {
            DataTable ledgerTable = ledger.GetAll();
            DataTable prevYearLedgerTable = prevYearLedger.GetAll();
            if (ledgerTable != null)
            {
                int numberOfMonthsBalance = 0;
                int totalBalance = 0;
                int oldBalance = 0;
                string todaysDate = string.Empty;
                double progress = 0.0;
                int totalAmtPaid = 0;

                try
                {
                    foreach (DataRow ledgerRow in ledgerTable.Rows)
                    {
                        progress++;
                        //Report progress
                        progressVar = Convert.ToInt32((progress / ledgerTable.Rows.Count) * 100);
                        ledger.InitLedgerObj(ledgerRow);
                        CustomerDetailsTable customer = GetCustomer(ledger.CustID);
                        if (customer.BillingCategoryTable.Frequency > 0 && customer.Active)
                        {
                            int amountPerMonth = customer.BillingCategoryTable.Amount / customer.BillingCategoryTable.Frequency;
                            numberOfMonthsBalance = 0;
                            totalBalance = 0;
                            totalAmtPaid = 0;

                            if (prevYearLedgerTable != null)
                                oldBalance = prevYearLedger.GetCustomerTotalBalance(ledger.CustID);

                            for (int i = 1; i <= endMonth; i++)
                            {
                                if(ledger.Bill[i].Trim() == "na")
                                {
                                    continue;
                                }
                                else if (ledger.Bill[i] == "np")
                                {
                                    numberOfMonthsBalance++;
                                    if (ledger.Bal[i].Trim() == string.Empty || ledger.Bal[i] != amountPerMonth.ToString())
                                        ledger.Bal[i] = amountPerMonth.ToString();
                                    totalBalance += int.Parse(ledger.Bal[i]);
                                }
                                //Case Bill is empty and Bal is empty, update with monthly balance
                                else if(string.IsNullOrWhiteSpace(ledger.Bill[i]) && string.IsNullOrWhiteSpace(ledger.Bal[i]))
                                {
                                    ledger.Bal[i] = amountPerMonth.ToString();
                                    totalBalance += int.Parse(ledger.Bal[i]);
                                }
                                //Case Bill is empty and Bal is 125
                                else if (ledger.Bal[i].Trim() != "" && ledger.Bal[i].Trim() != "0")
                                {
                                    numberOfMonthsBalance++;
                                    totalBalance += int.Parse(ledger.Bal[i]);
                                }

                            }

                            //Calculate the total amount paid from Jan till Dec.
                            for (int i = 1; i <= 12; i++)
                            {
                                int amount = 0;
                                string amountStr = ledger.Amt[i];
                                //Put it in a separate for loop
                                if (!string.IsNullOrWhiteSpace(amountStr))
                                {
                                    //If the amount part contains more than one payment, it is separated by "-"
                                    if (amountStr.Contains("-"))
                                    {
                                        string[] amtSplit = amountStr.Split('-');
                                        foreach (string amt in amtSplit)
                                        {
                                            if (int.TryParse(amt.Trim(), out amount))
                                                totalAmtPaid += amount;
                                        }
                                    }
                                    else if (int.TryParse(amountStr, out amount))
                                        totalAmtPaid += amount;
                                }
                            }

                            totalBalance += oldBalance;
                            //If the old value is same, dont update the value again. This is will un-necessarily update the rows.
                            if (ledger.NumOfMonthsBal.ToString() != numberOfMonthsBalance.ToString())
                                ledger.NumOfMonthsBal= numberOfMonthsBalance;
                            if (ledger.TotalBalance.ToString() != totalBalance.ToString())
                                ledger.TotalBalance = totalBalance;
                            if (ledger.OldBalance.ToString() != oldBalance.ToString())
                                ledger.OldBalance =  oldBalance;
                            if (ledger.TotalAmtPaid.ToString() != totalAmtPaid.ToString())
                                ledger.TotalAmtPaid = totalAmtPaid;


                            ledger.Update();
                        }
                    }
                    
                    todaysDate = DateTime.Now.Day.ToString() + "/" + DateTime.Now.Month.ToString() + "/" + DateTime.Now.Year.ToString();
                    CompanyTable company = db.CompanyTables.SingleOrDefault(c => c.FinancialYear == DateTime.Now.Year.ToString());
                    if (company != null)
                        company.LastUpdateDate = todaysDate;
                    db.SaveChanges();
                }
                catch
                {
                }
            }
        }

        private void BalanceUpdateTillCurrentMonth()
        {
            BalanceUpdateTillMonth(DateTime.Now.Month);
        }

        private void BalanceUpdateTillDecember()
        {
            BalanceUpdateTillMonth(12);
        }

        private void BalanceUpdateTillPreviousMonth()
        {
            if (DateTime.Now.Month > 1)
                BalanceUpdateTillMonth(DateTime.Now.Month - 1);
        }

        private CustomerDetailsTable GetCustomer(int custId)
        {
            return db.CustomerDetailsTables.SingleOrDefault(c => c.ID == custId);
        }
    }
}