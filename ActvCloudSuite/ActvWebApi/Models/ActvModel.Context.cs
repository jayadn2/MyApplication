﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class ActvEntities : DbContext
    {
        public ActvEntities()
            : base("name=ActvEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<EmployeeTable> EmployeeTables { get; set; }
        public virtual DbSet<login_info> login_info { get; set; }
        public virtual DbSet<MobileCollection> MobileCollections { get; set; }
        public virtual DbSet<MobileInfo> MobileInfoes { get; set; }
        public virtual DbSet<ACTVTransact> ACTVTransacts { get; set; }
        public virtual DbSet<AgentDetailsTable> AgentDetailsTables { get; set; }
        public virtual DbSet<AreaDetailsTable> AreaDetailsTables { get; set; }
        public virtual DbSet<LedgerTable> LedgerTables { get; set; }
        public virtual DbSet<CompanyTable> CompanyTables { get; set; }
        public virtual DbSet<BillingCategoryTable> BillingCategoryTables { get; set; }
        public virtual DbSet<CustomerDetailsTable> CustomerDetailsTables { get; set; }
        public virtual DbSet<AmountCollectionTable> AmountCollectionTables { get; set; }
    }
}