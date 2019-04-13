using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ActvMvcClient.Models
{
    public class AmountCollectionTableMetaData
    {
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}")]
        public Nullable<System.DateTime> CollectionDate2 { get; set; }
    }
}