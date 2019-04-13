using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ActvMvcClient.Models
{
    [MetadataType(typeof(CompanyTableMetaData))]
    public partial class CompanyTable
    {
        private ActvMvcClientEntities db = new ActvMvcClientEntities();

        public string GetCompanyNameForYear(string year)
        {
            string companyName = string.Empty;
            CompanyTable ct = db.CompanyTables.SingleOrDefault(c => c.FinancialYear == year);
            if (ct != null)
                companyName = ct.CompanyName;
            return companyName;
        }

        public CompanyTable GetPreviousYearCompany()
        {
            CompanyTable prevYearCompany = null;
                int prevYear = Convert.ToInt32(FinancialYear) - 1;
                prevYearCompany = db.CompanyTables.SingleOrDefault(c => c.CompanyId == CompanyId && c.FinancialYear == prevYear.ToString());
            return prevYearCompany;
        }

        public CompanyTable GetCompanyForYear(int year)
        {
            return db.CompanyTables.SingleOrDefault(c => c.FinancialYear == year.ToString());
        }
    }
}