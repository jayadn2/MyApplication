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
    
    public partial class AgentDetailsTable
    {
        public AgentDetailsTable()
        {
            this.AmountCollectionTables = new HashSet<AmountCollectionTable>();
            this.CustomerDetailsTables = new HashSet<CustomerDetailsTable>();
        }
    
        public int ID { get; set; }
        public string AgentCode { get; set; }
        public int AreaCode { get; set; }
        public int EmpNum { get; set; }
    
        public virtual ICollection<AmountCollectionTable> AmountCollectionTables { get; set; }
        public virtual AreaDetailsTable AreaDetailsTable { get; set; }
        public virtual EmployeeTable EmployeeTable { get; set; }
        public virtual ICollection<CustomerDetailsTable> CustomerDetailsTables { get; set; }
    }
}
