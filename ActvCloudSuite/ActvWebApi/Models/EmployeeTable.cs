//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ActvWebApi.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class EmployeeTable
    {
        public EmployeeTable()
        {
            this.AgentDetailsTables = new HashSet<AgentDetailsTable>();
            this.MobileInfoes = new HashSet<MobileInfo>();
            this.AmountCollectionTables = new HashSet<AmountCollectionTable>();
        }
    
        public int ID { get; set; }
        public string EmployeeName { get; set; }
        public string MobileNumber { get; set; }
        public string Address { get; set; }
    
        public virtual ICollection<AgentDetailsTable> AgentDetailsTables { get; set; }
        public virtual ICollection<MobileInfo> MobileInfoes { get; set; }
        public virtual ICollection<AmountCollectionTable> AmountCollectionTables { get; set; }
    }
}
