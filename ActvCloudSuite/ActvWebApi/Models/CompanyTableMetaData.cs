using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ActvWebApi.Models
{
    public class CompanyTableMetaData
    {
        [Required]
        [Display(Name = "Ledger Year")]
        [MaxLength(length: 4, ErrorMessage = "You can enter maximum 4 character")]
        [MinLength(length: 4, ErrorMessage = "You must enter minimum 4 character")]
        public string FinancialYear { get; set; }

        //[Required]
        //[Display(Name = "Start Month")]
        //[Range(minimum: 1, maximum: 12, ErrorMessage = "Month value should be between 1 to 12")]
        //public int StartMonth { get; set; }

        //[Required]
        //[Display(Name = "End Month")]
        //[Range(minimum: 1, maximum: 12, ErrorMessage = "Month value should be between 1 to 12")]
        //public int EndMonth { get; set; }

        [Required]
        [Display(Name = "Company")]
        public int CompanyId { get; set; }
    }
}