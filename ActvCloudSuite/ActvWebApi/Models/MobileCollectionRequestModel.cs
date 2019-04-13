using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ActvWebApi.Models
{
    public class MobileCollectionRequestModel
    {
        public int ID { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string EmpId { get; set; }
        public string StartBillNumber { get; set; }
        public string EndBillNumber { get; set; }
        public bool SearchOnBillNumber { get; set; }
    }
}