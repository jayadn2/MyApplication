using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using ActvMvcClient.Models;
using ActvMvcClient.DynamicTableModels;
using System.Configuration;
using System.Threading.Tasks;

namespace ActvMvcClient.Controllers
{
    [Authorize]
    public class CompanyTablesController : Controller
    {
        private ActvMvcClientEntities db = new ActvMvcClientEntities();
        private ActvMvcClientEntities newdb;
        private int taskId = 24;
        private static int progressVar;

        // GET: CompanyTables
        public ActionResult Index()
        {
            var companyTables = db.CompanyTables.Include(c => c.CompanyDetail);
            return View(companyTables.ToList());
        }

        // GET: CompanyTables/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            CompanyTable companyTable = db.CompanyTables.Find(id);
            if (companyTable == null)
            {
                return HttpNotFound();
            }
            return View(companyTable);
        }

        // GET: CompanyTables/Create
        public ActionResult Create()
        {
            ViewBag.CompanyId = new SelectList(db.CompanyDetails, "Id", "CompanyName");
            ViewBag.Error = "";
            return View();
        }

        // POST: CompanyTables/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [NoAsyncTimeout]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "ID,CompanyName,FinancialYear,StartMonth,EndMonth,LastUpdateDate,CompanyId")] CompanyTable companyTable)
        {
            newdb = new ActvMvcClientEntities();
            if (ModelState.IsValid)
            {


                if (!IsYearExistForCompany(companyTable.CompanyId, companyTable.FinancialYear))
                {

                    //Do work here
                    companyTable.StartMonth = 1;
                    companyTable.EndMonth = 12;
                    companyTable.CompanyName = newdb.CompanyDetails.FirstOrDefault(c => c.Id == companyTable.CompanyId).CompanyName;
                    companyTable.LastUpdateDate = DateTime.Today.ToString("dd/MM/yyyy");
                    newdb.CompanyTables.Add(companyTable);
                    newdb.SaveChanges();
                    LedgerTable ledgerTable = new LedgerTable(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                    ledgerTable.CreateLedgerTable(companyTable);
                    InsertCustomerIntoNewLedger(ledgerTable, companyTable);
                    //return RedirectToAction("Index");
                    newdb.SaveChanges();
                    ViewBag.CompanyId = new SelectList(newdb.CompanyDetails, "Id", "CompanyName", companyTable.CompanyId);
                    return View();
                }
                else
                {
                    //Display Error that Year already exist
                    ViewBag.Error = "Year already exist, please enter correct value.";
                    ViewBag.CompanyId = new SelectList(newdb.CompanyDetails, "Id", "CompanyName", companyTable.CompanyId);
                    return View(companyTable);
                }
            }

            ViewBag.CompanyId = new SelectList(newdb.CompanyDetails, "Id", "CompanyName", companyTable.CompanyId);
            //return View(companyTable);
            return View();
        }

        public ActionResult CreateCompleted(string result)
        {
            return View();
        }

        public ActionResult CreateProgress()
        {
            //Report progress
            HttpContext.Application["task" + taskId] = progressVar;
            return Json(new
            {
                Progress = HttpContext.Application["task" + taskId].ToString()
            }, JsonRequestBehavior.AllowGet);
        }


        private void InsertCustomerIntoNewLedger(LedgerTable ledgerTable, CompanyTable company)
        {
            //Insert all the customers into newly created ledger table.
            //Go through each customers in CustomerTable, Check the customer exist in Previous year table. If exist, update currenty year ledger with OldBalance, TotalBalance
            LedgerTable prevYearLedgerTable = new LedgerTable(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            int prevYear = int.Parse(company.FinancialYear) - 1;
            prevYearLedgerTable.TableName = prevYearLedgerTable.GetLedgerTableNameForYear(company.GetPreviousYearCompany());
            bool prevYearLedgerExist = false;
            prevYearLedgerExist = prevYearLedgerTable.IsTableExist(prevYearLedgerTable.TableName);
            double progress = 0.0;
            foreach (CustomerDetailsTable customer in newdb.CustomerDetailsTables)
            {
                progress++;
                //Report progress
                progressVar = Convert.ToInt32((progress / newdb.CustomerDetailsTables.Count()) * 100);

                ledgerTable.InitLedgerToDefaultValues();
                ledgerTable.CustID = customer.ID;
                ledgerTable.CustCode = customer.CustomerCode;
                ledgerTable.AgentCode = customer.AgentCode;
                ledgerTable.AreaCode = customer.AreaCode;
                ledgerTable.OldBalance = customer.InitialBalance;
                ledgerTable.TotalBalance = customer.InitialBalance;
                
                if (prevYearLedgerExist)
                {
                    prevYearLedgerTable.GetCustomerLedger(customer.ID);

                    //billNumber = prevYearLedgerTable.Bill[12];
                    //billDate = prevYearLedgerTable.Date[12];
                    //billAmount = prevYearLedgerTable.Amt[12];

                    ledgerTable.OldBalance = prevYearLedgerTable.TotalBalance;
                    ledgerTable.TotalBalance = prevYearLedgerTable.TotalBalance;
                    
                }
                ledgerTable.InsertLedgerEntry();
                //If the old balance has negative balance, the customer has paid advance amount.
                if (ledgerTable.OldBalance < 0)
                {
                    AllocateAdvanceAmount(ledgerTable.OldBalance, prevYearLedgerTable.Bill[12], prevYearLedgerTable.Amt[12], prevYearLedgerTable.Amt[12], ledgerTable);
                }
                
            }
        }

        private void AllocateAdvanceAmount(int advanceAmount, string billNumber, string billDate, string billAmount, LedgerTable ledgerTable)
        {
            if (advanceAmount < 0)
                advanceAmount *= -1;

            if (advanceAmount > 0)
            {
                InsertAmount(advanceAmount, billNumber, billDate, billAmount, ledgerTable);
            }

            ledgerTable.Update();
            //Update the customertable
            CustomerDetailsTable customer = newdb.CustomerDetailsTables.SingleOrDefault(c => c.ID == ledgerTable.CustID);
            customer.InitialBalance = ledgerTable.OldBalance;
            //newdb.SaveChanges();
        }

        private void InsertAmount(int amount, string billNumber, string billDate, string billAmount, LedgerTable ledgerTable)
        {
            int amountPaid = amount;
            int monthNum = 1;
            int monthlyBalance = ledgerTable.GetPaymentFreqAmt();
            while ((amountPaid > 0) && (monthNum < 13))
            {
                switch (monthNum++)
                {
                    case 1:
                        this.AllocateAmount(amount, ref amountPaid, 1, billNumber, billDate, billAmount, ledgerTable, monthlyBalance);
                        break;

                    case 2:
                        this.AllocateAmount(amount, ref amountPaid, 2, billNumber, billDate, billAmount, ledgerTable, monthlyBalance);
                        break;

                    case 3:
                        this.AllocateAmount(amount, ref amountPaid, 3, billNumber, billDate, billAmount, ledgerTable, monthlyBalance);
                        break;

                    case 4:
                        this.AllocateAmount(amount, ref amountPaid, 4, billNumber, billDate, billAmount, ledgerTable, monthlyBalance);
                        break;

                    case 5:
                        this.AllocateAmount(amount, ref amountPaid, 5, billNumber, billDate, billAmount, ledgerTable, monthlyBalance);
                        break;

                    case 6:
                        this.AllocateAmount(amount, ref amountPaid, 6, billNumber, billDate, billAmount, ledgerTable, monthlyBalance);
                        break;

                    case 7:
                        this.AllocateAmount(amount, ref amountPaid, 7, billNumber, billDate, billAmount, ledgerTable, monthlyBalance);
                        break;

                    case 8:
                        this.AllocateAmount(amount, ref amountPaid, 8, billNumber, billDate, billAmount, ledgerTable, monthlyBalance);
                        break;

                    case 9:
                        this.AllocateAmount(amount, ref amountPaid, 9, billNumber, billDate, billAmount, ledgerTable, monthlyBalance);
                        break;

                    case 10:
                        this.AllocateAmount(amount, ref amountPaid, 10, billNumber, billDate, billAmount, ledgerTable, monthlyBalance);
                        break;

                    case 11:
                        this.AllocateAmount(amount, ref amountPaid, 11, billNumber, billDate, billAmount, ledgerTable, monthlyBalance);
                        break;

                    case 12:
                        this.AllocateAmount(amount, ref amountPaid, 12, billNumber, billDate, billAmount, ledgerTable, monthlyBalance);
                        break;
                }
            }
            if (amountPaid <= 0)
            {
                ledgerTable.TotalBalance = 0;
                ledgerTable.OldBalance = 0;
            }
            else
            {
                amountPaid *= -1;
                ledgerTable.TotalBalance = amountPaid;
                ledgerTable.OldBalance = amountPaid;
            }
        }

        private void AllocateAmount(int totalBalanceAmount, ref int remainingAmount, int monthNum, string billNumber, string billDate, string billAmount, LedgerTable ledgerTable, int monthlyBalance)
        {
            

            if (remainingAmount > 0 && monthlyBalance > 0)
            {
                if (remainingAmount >= monthlyBalance)
                {
                    remainingAmount -= monthlyBalance;
                    ledgerTable.Bal[monthNum] = "0";
                }
                else
                {
                    monthlyBalance -= remainingAmount;
                    remainingAmount = 0;
                    ledgerTable.Bal[monthNum] = monthlyBalance.ToString();
                }
                ledgerTable.Bill[monthNum] = billNumber;
                ledgerTable.Amt[monthNum] = billAmount;
                ledgerTable.Date[monthNum] = billDate.ToString();
            }
        }

        private bool IsYearExistForCompany(int companyId, string year)
        {
            return db.CompanyTables.Any(c => c.CompanyId == companyId && c.FinancialYear == year);
        }

        // GET: CompanyTables/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            CompanyTable companyTable = db.CompanyTables.Find(id);
            if (companyTable == null)
            {
                return HttpNotFound();
            }
            ViewBag.CompanyId = new SelectList(db.CompanyDetails, "Id", "CompanyName", companyTable.CompanyId);
            return View(companyTable);
        }

        // POST: CompanyTables/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ID,CompanyName,FinancialYear,StartMonth,EndMonth,LastUpdateDate,CompanyId")] CompanyTable companyTable)
        {
            if (ModelState.IsValid)
            {
                db.Entry(companyTable).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.CompanyId = new SelectList(db.CompanyDetails, "Id", "CompanyName", companyTable.CompanyId);
            return View(companyTable);
        }

        // GET: CompanyTables/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            CompanyTable companyTable = db.CompanyTables.Find(id);
            if (companyTable == null)
            {
                return HttpNotFound();
            }
            return View(companyTable);
        }

        // POST: CompanyTables/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            CompanyTable companyTable = db.CompanyTables.Find(id);
            db.CompanyTables.Remove(companyTable);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
