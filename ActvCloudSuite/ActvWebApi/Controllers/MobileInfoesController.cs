using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using ActvWebApi.Models;

namespace ActvWebApi.Controllers
{
    [Authorize]
    public class MobileInfoesController : ApiController
    {
        private ActvEntities db = new ActvEntities();

        // GET: api/MobileInfoes
        public IQueryable<MobileInfo> GetMobileInfoes()
        {
            return db.MobileInfoes;
        }

        // GET: api/MobileInfoes/5
        [ResponseType(typeof(MobileInfo))]
        public IHttpActionResult GetMobileInfo(int id)
        {
            MobileInfo mobileInfo = db.MobileInfoes.Find(id);
            if (mobileInfo == null)
            {
                return NotFound();
            }

            return Ok(mobileInfo);
        }

        // PUT: api/MobileInfoes/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutMobileInfo(int id, MobileInfo mobileInfo)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != mobileInfo.Id)
            {
                return BadRequest();
            }

            db.Entry(mobileInfo).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!MobileInfoExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return StatusCode(HttpStatusCode.NoContent);
        }

        // POST: api/MobileInfoes
        [ResponseType(typeof(MobileInfo))]
        public IHttpActionResult PostMobileInfo(MobileInfo mobileInfo)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.MobileInfoes.Add(mobileInfo);
            db.SaveChanges();

            return CreatedAtRoute("DefaultApi", new { id = mobileInfo.Id }, mobileInfo);
        }

        // DELETE: api/MobileInfoes/5
        [ResponseType(typeof(MobileInfo))]
        public IHttpActionResult DeleteMobileInfo(int id)
        {
            MobileInfo mobileInfo = db.MobileInfoes.Find(id);
            if (mobileInfo == null)
            {
                return NotFound();
            }

            db.MobileInfoes.Remove(mobileInfo);
            db.SaveChanges();

            return Ok(mobileInfo);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool MobileInfoExists(int id)
        {
            return db.MobileInfoes.Count(e => e.Id == id) > 0;
        }
    }
}