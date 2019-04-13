using ActvWebApi.DynamicTableModels;
using ActvWebApi.Models;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Description;
using System.Linq;
using System.Collections.Specialized;
using System.Web;

namespace ActvWebApi.Controllers
{
    [Authorize]
    public class LedgerController : ApiController
    {

        LedgerOps ledgerOps = new LedgerOps();
        // GET: api/Ledger
        public IList<MobileInfo> GetLedger()
        {
            return null;
        }

        // GET: api/Ledger/5
        [ResponseType(typeof(MobileInfo))]
        public LedgerResponseModel GetLedger(int id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);
            var companyYear = nvc["companyYear"];
            int year = 0;
            //MobileInfo mobileInfo = db.MobileInfoes.Find(id);
            if (companyYear != null && int.TryParse(companyYear, out year))
            {
                CompanyTable company = new CompanyTable();
                company = company.GetCompanyForYear(year);
                LedgerResponseModel ledgerResponse = ledgerOps.GetLedger(id, company);
                return ledgerResponse;
            }
            else
                return null;
        }

        // POST: api/Ledger
        [ResponseType(typeof(string))]
        public IHttpActionResult PostLedger(IList<LedgerEntryModel> ledgerEntryDetails)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            List<LedgerEntryModel> addedEntries = new List<LedgerEntryModel>();
            List<LedgerEntryModel> notAddedEntries = null;
            if (ledgerEntryDetails != null)
            {
                LedgerOps ledgerOperations = new LedgerOps();
                foreach (LedgerEntryModel ledgerEntry in ledgerEntryDetails)
                {
                    CompanyTable company = new CompanyTable();
                    company = company.GetCompanyForYear(ledgerEntry.CompanyYear);

                    ledgerOperations.BeginUpdateLedger(ledgerEntry.CustomerId, ledgerEntry.Amount, company, ledgerEntry.BillDate, ledgerEntry.BillNum, ledgerEntry.EmpId, ledgerEntry.AgentCode);
                    addedEntries.Add(ledgerEntry);
                }
                notAddedEntries = ledgerEntryDetails.Where(l => !IsPresentInList(addedEntries, l)).ToList();
            }

            return CreatedAtRoute("DefaultApi", notAddedEntries, notAddedEntries);
        }

        private bool IsPresentInList(List<LedgerEntryModel> addedEntries, LedgerEntryModel l)
        {
            return addedEntries.Any(a => a.CustomerId == l.CustomerId && a.BillNum == l.BillNum);
        }
    }
}
