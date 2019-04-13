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
using ActvWebApi.HelperClasses;
using System.Collections;
using Newtonsoft.Json;

namespace ActvWebApi.Controllers
{
    [Authorize]
    public class CustomerDetailsController : ApiController
    {
        private ActvEntities db = new ActvEntities();

        // GET: api/CustomerDetails
        public IQueryable<CustomerDetailsTable> GetCustomerDetailsTables()
        {
            return db.CustomerDetailsTables;
        }

        // GET: api/CustomerDetails/5
        [ResponseType(typeof(CustomerDetailsTable))]
        public IHttpActionResult GetCustomerDetailsTable(int id)
        {
            if(db.login_info.Any(li => li.empid==id && li.usertype.ToLower()=="admin"))//if admin user, list all the customers
            {
                var customers = db.CustomerDetailsTables.Select(o => new { o.CustomerName, o.ID }).ToList();

                if (customers == null)
                {
                    return NotFound();
                }

                return Ok(customers.ToList());
            }
            else
            {
                //id = int.Parse(HelperClass.Base64Decode(id));
                int empIdInt = id;

                IEnumerable<AgentDetailsTable> agentIds = db.AgentDetailsTables.Where(a => a.EmpNum == empIdInt);

                var customers = db.CustomerDetailsTables.Where(c => agentIds.Any(a => c.AgentCode == a.AgentCode)).Select(o => new { o.CustomerName, o.ID });
                //CustomerDetailsTable customerDetailsTable = db.CustomerDetailsTables.Find(id);
                if (customers == null)
                {
                    return NotFound();
                }

                return Ok(customers.ToList());
            }
        }

        // PUT: api/CustomerDetails/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutCustomerDetailsTable(int id, CustomerDetailsTable customerDetailsTable)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != customerDetailsTable.CustomerCode)
            {
                return BadRequest();
            }

            db.Entry(customerDetailsTable).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CustomerDetailsTableExists(id))
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

        // POST: api/CustomerDetails
        [ResponseType(typeof(CustomerDetailsTable))]
        public IHttpActionResult PostCustomerDetailsTable(CustomerDetailsTable customerDetailsTable)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.CustomerDetailsTables.Add(customerDetailsTable);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (CustomerDetailsTableExists(customerDetailsTable.CustomerCode))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = customerDetailsTable.CustomerCode }, customerDetailsTable);
        }

        // DELETE: api/CustomerDetails/5
        [ResponseType(typeof(CustomerDetailsTable))]
        public IHttpActionResult DeleteCustomerDetailsTable(int id)
        {
            CustomerDetailsTable customerDetailsTable = db.CustomerDetailsTables.Find(id);
            if (customerDetailsTable == null)
            {
                return NotFound();
            }

            db.CustomerDetailsTables.Remove(customerDetailsTable);
            db.SaveChanges();

            return Ok(customerDetailsTable);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool CustomerDetailsTableExists(int id)
        {
            return db.CustomerDetailsTables.Count(e => e.CustomerCode == id) > 0;
        }
    }
}