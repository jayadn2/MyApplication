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
using System.Globalization;
using ActvWebApi.HelperClasses;

namespace ActvWebApi.Controllers
{
    public class MobileCollectionRequestModelsController : ApiController
    {
        private ActvEntities db = new ActvEntities();

        // GET: api/MobileCollectionRequestModels
        public IQueryable<MobileCollectionRequestModel> GetMobileCollectionRequestModels()
        {
            return db.MobileCollectionRequestModels;
        }

        // GET: api/MobileCollectionRequestModels/5
        [ResponseType(typeof(MobileCollectionRequestModel))]
        public IHttpActionResult GetMobileCollectionRequestModel(int id)
        {
            MobileCollectionRequestModel mobileCollectionRequestModel = db.MobileCollectionRequestModels.Find(id);
            if (mobileCollectionRequestModel == null)
            {
                return NotFound();
            }

            return Ok(mobileCollectionRequestModel);
        }

        // PUT: api/MobileCollectionRequestModels/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutMobileCollectionRequestModel(int id, MobileCollectionRequestModel mobileCollectionRequestModel)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != mobileCollectionRequestModel.ID)
            {
                return BadRequest();
            }

            db.Entry(mobileCollectionRequestModel).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!MobileCollectionRequestModelExists(id))
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

        // POST: api/MobileCollectionRequestModels
        [ResponseType(typeof(MobileCollectionResponseListModel))]
        public IHttpActionResult PostMobileCollectionRequestModel(MobileCollectionRequestModel mobileCollectionRequestModel)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            DateTime fromDate = DateTime.Today;
            DateTime toDate = DateTime.Today;
            int fromBillNumber;
            int toBillNumber;
            MobileCollectionResponseListModel mobileCollectionResponseListModel = new MobileCollectionResponseListModel();
            IQueryable<MobileCollection> collectionResult = null;
            int empId = 0;
            int.TryParse(mobileCollectionRequestModel.EmpId, out empId);
            int adminUser = 0;
            adminUser = UserValidationHelper.IsAdminUser(empId);
            if (mobileCollectionRequestModel.SearchOnBillNumber)
            {
                fromBillNumber = int.Parse(mobileCollectionRequestModel.StartBillNumber);
                toBillNumber = int.Parse(mobileCollectionRequestModel.EndBillNumber);
                if(adminUser > 0) //If the user is admin, return all the employees entries in the range
                {
                    collectionResult = db.MobileCollections.Where(mc => mc.RecieptNo >= fromBillNumber && mc.RecieptNo <= toBillNumber);
                }
                else
                {
                    collectionResult = db.MobileCollections.Where(mc => mc.EmpId == empId && mc.RecieptNo >= fromBillNumber && mc.RecieptNo <= toBillNumber);
                }
            }
            else
            {
                mobileCollectionRequestModel.FromDate = DateFormat.FormatDateBeforeConversion(mobileCollectionRequestModel.FromDate);
                mobileCollectionRequestModel.ToDate = DateFormat.FormatDateBeforeConversion(mobileCollectionRequestModel.ToDate);
                DateTime.TryParseExact(mobileCollectionRequestModel.FromDate, DateFormat.AppDateFormat, new CultureInfo("en-US"), DateTimeStyles.None, out fromDate);
                DateTime.TryParseExact(mobileCollectionRequestModel.ToDate, DateFormat.AppDateFormat, new CultureInfo("en-US"), DateTimeStyles.None, out toDate);
                if (adminUser > 0) //If the user is admin, return all the employees entries in the range
                {
                    collectionResult = db.MobileCollections.Where(mc => mc.CollectionDate >= fromDate && mc.CollectionDate <= toDate);
                }
                else
                {
                    collectionResult = db.MobileCollections.Where(mc => mc.EmpId == empId && mc.CollectionDate >= fromDate && mc.CollectionDate <= toDate);
                }
            }
            if (collectionResult != null && collectionResult.Count() > 0)
            {
                mobileCollectionResponseListModel.ReslutCollection = new List<MobileCollectionResponseModel>(collectionResult.Count());
                foreach(MobileCollection mc in collectionResult)
                {
                    mobileCollectionResponseListModel.NoOfBills++;
                    mobileCollectionResponseListModel.TotalAmountCollection += mc.Amount;
                    MobileCollectionResponseModel mcr = new MobileCollectionResponseModel(mc);
                    CustomerDetailsTable customer = db.CustomerDetailsTables.FirstOrDefault(c => c.ID == mc.CustomerId);
                    mcr.CustomerName = customer.CustomerName;
                    mobileCollectionResponseListModel.ReslutCollection.Add(mcr);
                }
                return Ok(mobileCollectionResponseListModel);
            }

            return StatusCode(HttpStatusCode.NoContent);
            
        }

        // DELETE: api/MobileCollectionRequestModels/5
        [ResponseType(typeof(MobileCollectionRequestModel))]
        public IHttpActionResult DeleteMobileCollectionRequestModel(int id)
        {
            MobileCollectionRequestModel mobileCollectionRequestModel = db.MobileCollectionRequestModels.Find(id);
            if (mobileCollectionRequestModel == null)
            {
                return NotFound();
            }

            db.MobileCollectionRequestModels.Remove(mobileCollectionRequestModel);
            db.SaveChanges();

            return Ok(mobileCollectionRequestModel);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool MobileCollectionRequestModelExists(int id)
        {
            return db.MobileCollectionRequestModels.Count(e => e.ID == id) > 0;
        }
    }
}