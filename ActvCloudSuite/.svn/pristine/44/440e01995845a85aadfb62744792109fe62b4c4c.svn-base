using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ActvMvcClient.Models
{
    public class MobileCollectionExt : MobileCollection
    {
        public EmployeeTable EmpTable { get; set; }
        public MobileCollectionExt(MobileCollection mobileCollection, EmployeeTable empTable)
        {
            Id = mobileCollection.Id;
            RecieptNo = mobileCollection.RecieptNo;
            CustomerId = mobileCollection.CustomerId;
            Amount = mobileCollection.Amount;
            CollectionDate = mobileCollection.CollectionDate;
            EmpId = mobileCollection.EmpId;
            GpsLocation = mobileCollection.GpsLocation;
            LedgerUpdated = mobileCollection.LedgerUpdated;
            EmpTable = empTable;
        }
    }
}