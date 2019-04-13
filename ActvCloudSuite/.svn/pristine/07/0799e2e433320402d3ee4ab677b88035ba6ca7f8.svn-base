using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using ActvMvcClient.Models;
using PagedList;

namespace ActvMvcClient.Controllers
{
    [Authorize]
    public class AmountCollectionTablesController : Controller
    {
        private ActvMvcClientEntities db = new ActvMvcClientEntities();

        // GET: AmountCollectionTables
        public ActionResult Index(string sortOrder, string currentFilter, string searchString, int? page, string collectionSource)
        {
            return CommonIndex(sortOrder, currentFilter, searchString, page, collectionSource, null, null);
        }


        [HttpPost]
        public ActionResult Index(string sortOrder, string currentFilter, string searchString, int? page, string collectionSource, DateTime? from, DateTime? to)
        {
            return CommonIndex(sortOrder,currentFilter,searchString,page,collectionSource,from,to);
        }

        private ActionResult CommonIndex(string sortOrder, string currentFilter, string searchString, int? page, string collectionSource, DateTime? from, DateTime? to)
        {
            collectionSource = Enum.GetName(typeof(CollectionSourceEnum), CollectionSourceEnum.mb);
            int pageSize = 20;
            int pageNumber = (page ?? 1);

            ViewBag.CurrentSort = sortOrder;
            ViewBag.NameSortParm = sortOrder == "name_asc" ? "name_desc" : "name_asc";
            ViewBag.DateSortParm = sortOrder == "Date" ? "date_desc" : "Date";

            if (searchString != null)
            {
                page = 1;
            }
            else
            {
                searchString = currentFilter;
            }
            ViewBag.CurrentFilter = searchString;
            IQueryable<AmountCollectionTable> coll;
            //var coll = db.AmountCollectionTables.Take(20).Include(a => a.AgentDetailsTable).Include(a => a.EmployeeTable).Include(a => a.CustomerDetailsTable);
            if (from != null && to != null)
            {
                 coll = db.AmountCollectionTables.Where(act => act.CollectionSource == collectionSource && act.CollectionDate2 >= from && act.CollectionDate2 <= to).Include(a => a.AgentDetailsTable).Include(a => a.EmployeeTable).Include(a => a.CustomerDetailsTable);
            }
            else
            {
                 coll = db.AmountCollectionTables.Where(act => act.CollectionSource == collectionSource).Include(a => a.AgentDetailsTable).Include(a => a.EmployeeTable).Include(a => a.CustomerDetailsTable);

            }
            if (!String.IsNullOrEmpty(searchString))
            {
                coll = coll.Where(c => c.CustomerDetailsTable.CustomerName.Contains(searchString)
                || c.BillNum.ToString().Contains(searchString));
            }
            switch (sortOrder)
            {
                case "name_desc":
                    coll = coll.OrderByDescending(c => c.CustomerDetailsTable.CustomerName);
                    break;
                case "name_asc":
                    coll = coll.OrderBy(c => c.CustomerDetailsTable.CustomerName);
                    break;
                case "Date":
                    coll = coll.OrderBy(c => c.CollectionDate2);
                    break;
                case "date_desc":
                    coll = coll.OrderByDescending(c => c.CollectionDate2);
                    break;
                default:
                    coll = coll.OrderBy(c => c.BillNum);
                    break;
            }

            return View(coll.ToPagedList(pageNumber, pageSize));
        }


        // GET: AmountCollectionTables/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            AmountCollectionTable amountCollectionTable = db.AmountCollectionTables.Find(id);
            if (amountCollectionTable == null)
            {
                return HttpNotFound();
            }
            return View(amountCollectionTable);
        }

        // GET: AmountCollectionTables/Create
        public ActionResult Create()
        {
            ViewBag.AgentCode = new SelectList(db.AgentDetailsTables, "AgentCode", "AgentCode");
            ViewBag.EmpID = new SelectList(db.EmployeeTables, "ID", "EmployeeName");
            ViewBag.CustomerID = new SelectList(db.CustomerDetailsTables, "ID", "CustomerName");
            return View();
        }

        // POST: AmountCollectionTables/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "ID,EmpID,AgentCode,CustomerID,CollectionAmount,BillNum,BillBookNum,CollectionDate,CollectionSource,CollectionDate2")] AmountCollectionTable amountCollectionTable)
        {
            if (ModelState.IsValid)
            {
                db.AmountCollectionTables.Add(amountCollectionTable);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.AgentCode = new SelectList(db.AgentDetailsTables, "AgentCode", "AgentCode", amountCollectionTable.AgentCode);
            ViewBag.EmpID = new SelectList(db.EmployeeTables, "ID", "EmployeeName", amountCollectionTable.EmpID);
            ViewBag.CustomerID = new SelectList(db.CustomerDetailsTables, "ID", "CustomerName", amountCollectionTable.CustomerID);
            return View(amountCollectionTable);
        }

        // GET: AmountCollectionTables/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            AmountCollectionTable amountCollectionTable = db.AmountCollectionTables.Find(id);
            if (amountCollectionTable == null)
            {
                return HttpNotFound();
            }
            ViewBag.AgentCode = new SelectList(db.AgentDetailsTables, "AgentCode", "AgentCode", amountCollectionTable.AgentCode);
            ViewBag.EmpID = new SelectList(db.EmployeeTables, "ID", "EmployeeName", amountCollectionTable.EmpID);
            ViewBag.CustomerID = new SelectList(db.CustomerDetailsTables, "ID", "CustomerName", amountCollectionTable.CustomerID);
            return View(amountCollectionTable);
        }

        // POST: AmountCollectionTables/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ID,EmpID,AgentCode,CustomerID,CollectionAmount,BillNum,BillBookNum,CollectionDate,CollectionSource,CollectionDate2")] AmountCollectionTable amountCollectionTable)
        {
            if (ModelState.IsValid)
            {
                db.Entry(amountCollectionTable).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.AgentCode = new SelectList(db.AgentDetailsTables, "AgentCode", "AgentCode", amountCollectionTable.AgentCode);
            ViewBag.EmpID = new SelectList(db.EmployeeTables, "ID", "EmployeeName", amountCollectionTable.EmpID);
            ViewBag.CustomerID = new SelectList(db.CustomerDetailsTables, "ID", "CustomerName", amountCollectionTable.CustomerID);
            return View(amountCollectionTable);
        }

        // GET: AmountCollectionTables/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            AmountCollectionTable amountCollectionTable = db.AmountCollectionTables.Find(id);
            if (amountCollectionTable == null)
            {
                return HttpNotFound();
            }
            return View(amountCollectionTable);
        }

        // POST: AmountCollectionTables/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            AmountCollectionTable amountCollectionTable = db.AmountCollectionTables.Find(id);
            db.AmountCollectionTables.Remove(amountCollectionTable);
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
