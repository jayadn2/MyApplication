//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ActvMvcClient.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class AmountCollectionTable
    {
        public int ID { get; set; }
        public int EmpID { get; set; }
        public string AgentCode { get; set; }
        public int CustomerID { get; set; }
        public int CollectionAmount { get; set; }
        public int BillNum { get; set; }
        public Nullable<int> BillBookNum { get; set; }
        public string CollectionDate { get; set; }
        public string CollectionSource { get; set; }
        public Nullable<System.DateTime> CollectionDate2 { get; set; }
    
        public virtual AgentDetailsTable AgentDetailsTable { get; set; }
        public virtual EmployeeTable EmployeeTable { get; set; }
        public virtual CustomerDetailsTable CustomerDetailsTable { get; set; }
    }
}
