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

namespace ActvMvcClient.Controllers
{
    [Authorize]
    public class MobileCollectionsController : Controller
    {
        private ActvMvcClientEntities db = new ActvMvcClientEntities();

        //// GET: MobileCollections
        //public ActionResult Index()
        //{
        //    ViewBag.EmpId = new SelectList(db.EmployeeTables, "ID", "EmployeeName");
        //    IList<MobileCollectionExt> mobileCollectionList = CreateMobileCollectionExtObj();
        //    return View(mobileCollectionList);
        //}

        // GET: MobileCollections
        public ActionResult Index(int id)
        {
            ViewBag.EmpId = new SelectList(db.EmployeeTables, "ID", "EmployeeName");
            IList<MobileCollectionExt> mobileCollectionList = CreateMobileCollectionExtObj();
            return View(mobileCollectionList.Where(m => m.EmpId == id).ToList());
        }

        public PartialViewResult MobileCollectionByEmpIdPartial(int id)
        {
            IList<MobileCollectionExt> mobileCollectionList = CreateMobileCollectionExtObj();
            return PartialView(mobileCollectionList.Where(m => m.EmpId == id).ToList());
        }

        private IList<MobileCollectionExt> CreateMobileCollectionExtObj()
        {
            List<MobileCollectionExt> mobileCollectionList = new List<MobileCollectionExt>();
            foreach (MobileCollection mc in db.MobileCollections)
            {
                EmployeeTable empTable = db.EmployeeTables.SingleOrDefault(e => e.ID == mc.EmpId);
                mobileCollectionList.Add(new MobileCollectionExt(mc, empTable));
            }
            return mobileCollectionList;
        }

        // GET: MobileCollections/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            MobileCollection mobileCollection = db.MobileCollections.Find(id);
            if (mobileCollection == null)
            {
                return HttpNotFound();
            }
            return View(mobileCollection);
        }

        public ActionResult RemoveDuplicateMobileCollectionEntriesIndex()
        {
            int currentYear = DateTime.Now.Year;
            CompanyTable currentYearCompany = db.CompanyTables.FirstOrDefault(c => c.FinancialYear == currentYear.ToString());
            currentYear--;
            if (currentYearCompany==null) //If current year ledger is not present, check for previous year ledger
                currentYearCompany = db.CompanyTables.FirstOrDefault(c => c.FinancialYear == currentYear.ToString());
            ViewBag.Company = new SelectList(db.CompanyTables, "ID", "FinancialYear", currentYearCompany.ID);
            return View();
        }

        [HttpPost]
        public ActionResult RemoveDuplicateMobileCollectionEntries(int? Company)
        {
            IList<LedgerTable> duplicateList = null;
            if (Company != null)
            {
                CompanyTable selectedCompany = db.CompanyTables.FirstOrDefault(c => c.ID == Company.Value);
                if (selectedCompany != null)
                {
                    LedgerOps ledgerOperations = new LedgerOps();
                    duplicateList = ledgerOperations.RemoveDuplicateMobileEntries(selectedCompany);
                    if(duplicateList != null)
                    {
                        duplicateList = duplicateList.OrderBy(d => d.CustID).ToList();
                    }
                }
            }
            return View(duplicateList);
        }

        // GET: MobileCollections/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: MobileCollections/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,RecieptNo,CustomerId,Amount,CollectionDate,EmpId,GpsLocation,LedgerUpdated")] MobileCollection mobileCollection)
        {
            if (ModelState.IsValid)
            {
                db.MobileCollections.Add(mobileCollection);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(mobileCollection);
        }

        // GET: MobileCollections/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            MobileCollection mobileCollection = db.MobileCollections.Find(id);
            if (mobileCollection == null)
            {
                return HttpNotFound();
            }
            return View(mobileCollection);
        }

        // POST: MobileCollections/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,RecieptNo,CustomerId,Amount,CollectionDate,EmpId,GpsLocation,LedgerUpdated")] MobileCollection mobileCollection)
        {
            if (ModelState.IsValid)
            {
                db.Entry(mobileCollection).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(mobileCollection);
        }

        // GET: MobileCollections/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            MobileCollection mobileCollection = db.MobileCollections.Find(id);
            if (mobileCollection == null)
            {
                return HttpNotFound();
            }
            return View(mobileCollection);
        }

        // POST: MobileCollections/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            MobileCollection mobileCollection = db.MobileCollections.Find(id);
            db.MobileCollections.Remove(mobileCollection);
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
