using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ActvWebApi.Models
{
    public class MobileCollectionResponseModel : MobileCollectionJson
    {
        public string CustomerName { get; set; }        

        public MobileCollectionResponseModel(MobileCollection mobileCollection) : base(mobileCollection)
        {
           
        }
    }
}