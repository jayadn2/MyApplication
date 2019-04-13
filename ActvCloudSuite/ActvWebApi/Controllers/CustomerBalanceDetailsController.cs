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
using ActvWebApi.DbSupport;
using System.Globalization;

namespace ActvWebApi.Controllers
{
    public class CustomerBalanceDetailsController : ApiController
    {
        private ActvEntities db = new ActvEntities();
        private ACTVDBQueryHelper actvQueryHelper = new ACTVDBQueryHelper();
        private IEnumerable<CompanyTable> latestYear;
        private CompanyTable latestYearCompany;
        private string currentYearTableName;

        public CustomerBalanceDetailsController()
        {
            latestYear = db.CompanyTables.OrderByDescending(c => c.FinancialYear).Take(1);
            if (latestYear != null && latestYear.Count() == 1)
            {
                latestYearCompany = latestYear.FirstOrDefault();
                currentYearTableName = "LedgerTable" + "_" + latestYearCompany.CompanyName + "_" + latestYearCompany.FinancialYear;
            }
        }

        // GET: api/CustomerBalanceDetails
        public IQueryable<CustomerDetailsTable> GetCustomerDetailsTables()
        {
            return db.CustomerDetailsTables;
        }

        // GET: api/CustomerBalanceDetails/5
        [ResponseType(typeof(CustomerBalanceDetail))]
        public IHttpActionResult GetCustomerDetailsTable(int id)
        {
            CustomerDetailsTable customerDetailsTable = db.CustomerDetailsTables.FirstOrDefault(c => c.ID == id);
            LedgerTable customerLedger = GetCustomerLatestledger(id);
            if (customerDetailsTable == null || customerLedger == null)
            {
                return NotFound();
            }

            CustomerBalanceDetail balanceDetail = new CustomerBalanceDetail();
            balanceDetail.CustId = customerDetailsTable.ID.ToString();
            balanceDetail.CustName = customerDetailsTable.CustomerName;
            balanceDetail.Adress = customerDetailsTable.Address;
            balanceDetail.TotalBalance = customerLedger.TotalBalance.ToString();
            balanceDetail.CurrentPayment = "0";
            balanceDetail.GpsLocation = "";

            return Ok(balanceDetail);
        }

        private LedgerTable GetCustomerLatestledger(int customerId)
        {
            LedgerTable customerLedger = null;
            string query = string.Format("Select * from {0} where CustID = {1}", currentYearTableName, customerId);
            DataTable resultTable = actvQueryHelper.ExecuteSelectStatement(query);
            if (resultTable != null && resultTable.Rows.Count == 1)
            {
                customerLedger = LedgerTable.CreateLedgerTable(resultTable.Rows[0]);
            }
            return customerLedger;
        }

        // PUT: api/CustomerBalanceDetails/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutCustomerDetailsTable(int id, CustomerBalanceDetail customerDetailsTable)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id.ToString() != customerDetailsTable.CustId)
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

        // POST: api/CustomerBalanceDetails
        [ResponseType(typeof(MobileCollectionJson))]
        public IHttpActionResult PostCustomerDetailsTable(CustomerBalanceDetail customerBalDetailsTable)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            
            MobileCollection collection = new MobileCollection();
            collection.Amount = int.Parse(customerBalDetailsTable.CurrentPayment);
            DateTime dateTimeVar;
            DateTime.TryParseExact(customerBalDetailsTable.CurrentPaymentDate, "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.AssumeLocal, out dateTimeVar);
            collection.CollectionDate = dateTimeVar;
            collection.CustomerId = int.Parse(customerBalDetailsTable.CustId);
            collection.EmpId = int.Parse(customerBalDetailsTable.EmpId);
            collection.GpsLocation = customerBalDetailsTable.GpsLocation;
            collection.LedgerUpdated = "f";
            if (db.MobileCollections.Count() >= 1)
                collection.RecieptNo = db.MobileCollections.Max(mc => mc.RecieptNo) + 1;
            else
                collection.RecieptNo = 1;
            db.MobileCollections.Add(collection);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (CustomerDetailsTableExists(int.Parse(customerBalDetailsTable.CustId)))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            MobileCollectionJson mobileCollectionJson = new MobileCollectionJson(collection);
            LedgerTable customerLedger = GetCustomerLatestledger(collection.CustomerId);
            if (customerLedger != null)
                mobileCollectionJson.LastBalance = customerLedger.TotalBalance.ToString();

            return Ok(mobileCollectionJson);
        }

        // DELETE: api/CustomerBalanceDetails/5
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