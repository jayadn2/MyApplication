using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ActvWebApi.Models
{
    public class MobileCollectionJson
    {

        public MobileCollectionJson()
        {

        }

        public MobileCollectionJson(MobileCollection mobileCollection)
        {
            Id = mobileCollection.Id.ToString();
            RecieptNo = mobileCollection.RecieptNo.ToString();
            CustomerId = mobileCollection.CustomerId.ToString();
            Amount = mobileCollection.Amount.ToString();
            CollectionDate = mobileCollection.CollectionDate.ToString(DateFormat.AppDateFormat);
            EmpId = mobileCollection.EmpId.ToString();
            GpsLocation = mobileCollection.GpsLocation;
            LedgerUpdated = mobileCollection.LedgerUpdated;
        }
        public string Id { get; set; }
        public string RecieptNo { get; set; }
        public string CustomerId { get; set; }
        public string Amount { get; set; }
        public string CollectionDate { get; set; }
        public string EmpId { get; set; }
        public string GpsLocation { get; set; }
        public string LedgerUpdated { get; set; }
        public string LastBalance { get; set; }
    }
}