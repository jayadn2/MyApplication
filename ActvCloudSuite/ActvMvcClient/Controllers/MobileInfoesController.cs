using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using ActvMvcClient.Models;

namespace ActvMvcClient.Controllers
{
    [Authorize]
    public class MobileInfoesController : Controller
    {
        private ActvMvcClientEntities db = new ActvMvcClientEntities();

        // GET: MobileInfoes
        public ActionResult Index()
        {
            var mobileInfoes = db.MobileInfoes.Include(m => m.EmployeeTable);
            return View(mobileInfoes.ToList());
        }

        // GET: MobileInfoes/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            MobileInfo mobileInfo = db.MobileInfoes.Find(id);
            if (mobileInfo == null)
            {
                return HttpNotFound();
            }
            return View(mobileInfo);
        }

        // GET: MobileInfoes/Create
        public ActionResult Create()
        {
            ViewBag.EmpId = new SelectList(db.EmployeeTables, "ID", "EmployeeName");
            return View();
        }

        // POST: MobileInfoes/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,MacId,EmpId,IsActive")] MobileInfo mobileInfo)
        {
            if (ModelState.IsValid)
            {
                if (!MobileInfoExist(mobileInfo.EmpId))
                {
                    db.MobileInfoes.Add(mobileInfo);
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
                else
                {
                    TempData["ErrorMsg"] = "The selected user is already present in the database. Pelase select different user.";
                    return View("Error");
                }
            }

            ViewBag.EmpId = new SelectList(db.EmployeeTables, "ID", "EmployeeName", mobileInfo.EmpId);
            return View(mobileInfo);
        }

        private bool MobileInfoExist(int empId)
        {
            MobileInfo duplicateEntry = db.MobileInfoes.SingleOrDefault(mob => mob.EmpId == empId);
            if (duplicateEntry == null)
                return false;
            else
                return true;
        }

        protected override void OnException(ExceptionContext filterContext)
        {
            if (!filterContext.ExceptionHandled)
            {
                string controller = filterContext.RouteData.Values["controller"].ToString();
                string action = filterContext.RouteData.Values["action"].ToString();

                Exception e = filterContext.Exception;
                filterContext.ExceptionHandled = true;
                ViewResult vr = new ViewResult();
                vr.ViewName = "Error";
                vr.TempData["ErrorMsg"] = e.Message;
                filterContext.Result = vr;                
            }
        }

        // GET: MobileInfoes/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            MobileInfo mobileInfo = db.MobileInfoes.Find(id);
            if (mobileInfo == null)
            {
                return HttpNotFound();
            }
            ViewBag.EmpId = new SelectList(db.EmployeeTables, "ID", "EmployeeName", mobileInfo.EmpId);
            return View(mobileInfo);
        }

        // POST: MobileInfoes/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,MacId,EmpId,IsActive")] MobileInfo mobileInfo)
        {
            if (ModelState.IsValid)
            {
                db.Entry(mobileInfo).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.EmpId = new SelectList(db.EmployeeTables, "ID", "EmployeeName", mobileInfo.EmpId);
            return View(mobileInfo);
        }

        // GET: MobileInfoes/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            MobileInfo mobileInfo = db.MobileInfoes.Find(id);
            if (mobileInfo == null)
            {
                return HttpNotFound();
            }
            return View(mobileInfo);
        }

        // POST: MobileInfoes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            MobileInfo mobileInfo = db.MobileInfoes.Find(id);
            db.MobileInfoes.Remove(mobileInfo);
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
