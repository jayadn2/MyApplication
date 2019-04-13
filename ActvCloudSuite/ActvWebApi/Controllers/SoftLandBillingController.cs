using ActvWebApi.DynamicTableModels;
using ActvWebApi.Models;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Description;
using System.Linq;

namespace ActvWebApi.Controllers
{
    public class SoftLandBillingController : ApiController
    {
        private ActvEntities db = new ActvEntities();
        // POST: api/CustomerDetails
        [ResponseType(typeof(string))]
        public IHttpActionResult PostSoftLandBilling(IList<SoftLandLedgerEntry> ledgerEntryDetails)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            List<SoftLandLedgerEntry> addedEntries = new List<SoftLandLedgerEntry>();
            List<SoftLandLedgerEntry> notAddedEntries = null;
            if (ledgerEntryDetails != null)
            {
                foreach (SoftLandLedgerEntry ledgerEntry in ledgerEntryDetails)
                {
                    CompanyTable company = new CompanyTable();
                    company = company.GetCompanyForYear(ledgerEntry.CompanyYear);

                    LedgerOps ledgerOperations = new LedgerOps();
                    ledgerOperations.BeginUpdateLedger(ledgerEntry.CustomerId, ledgerEntry.Amount, company, ledgerEntry.BillDate, ledgerEntry.BillNum, ledgerEntry.EmpId, ledgerEntry.AgentCode, ledgerEntry.CollectionSource);
                    ACTVTransact transact = new ACTVTransact();
                    transact.TransactId = ledgerEntry.TransactId;
                    transact.ReceiptNo = ledgerEntry.BillNum;
                    transact.AccountNo = ledgerEntry.CustomerId.ToString();
                    transact.CollectionAmount = ledgerEntry.Amount;
                    transact.CollectionDate = ledgerEntry.BillDate;
                    transact.InstalmentAmount = 0;
                    transact.Cancel = "N";
                    transact.AgentCode = ledgerEntry.AgentCode;
                    transact.CollectionTime = string.Empty;
                    transact.LedgerUpdated = "t";
                    db.ACTVTransacts.Add(transact);
                    db.SaveChanges();
                    addedEntries.Add(ledgerEntry);
                }
                notAddedEntries = ledgerEntryDetails.Where(l => !IsPresentInList(addedEntries, l)).ToList();
            }

            return CreatedAtRoute("DefaultApi", notAddedEntries, notAddedEntries);
        }

        private bool IsPresentInList(List<SoftLandLedgerEntry> addedEntries, SoftLandLedgerEntry l)
        {
            return addedEntries.Any(a => a.CustomerId == l.CustomerId && a.BillNum == l.BillNum);
        }
    }
}
