using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ActvWebApi.Models
{
    public class SoftLandLedgerEntry : LedgerEntry
    {
        public int TransactId { get; set; }
        public string AgentCode { get; set; }
        public string CollectionSource { get { return "sl"; } } //sl -> soft land billing machine
    }
}