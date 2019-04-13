using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ActvWebApi.DynamicTableModels
{
    public class BillNumberClass
    {
        private string[] billNumber;
        public BillNumberClass()
        {
            billNumber = new string[12];
            for (int i = 0; i < 12; i++)
            {
                billNumber[i] = LedgerTable.NotPaid;
            }
        }
        public string this[int i]
        {
            get
            {
                return billNumber[i - 1].Trim();  //i-1 means, from frontend, BillNumObj should be calculated for the months from 1 to 12, so if BillNumObj[1] should return billNumber[0]. 
            }
            set
            {
                billNumber[i - 1] = value;
            }
        }
    }

    public class AmountClass
    {
        private string[] amount;
        public AmountClass()
        {
            amount = new string[12];
            for (int i = 0; i < 12; i++)
            {
                amount[i] = "";
            }
        }
        public string this[int i]
        {
            get
            {
                return amount[i - 1].Trim();  //i-1 means, from frontend, amountObj should be calculated for the months from 1 to 12, so if amountObj[1] should return amount[0]. 
            }
            set
            {
                amount[i - 1] = value;
            }
        }
    }

    public class DateClass
    {
        private string[] dateArry;
        public DateClass()
        {
            dateArry = new string[12];
            for (int i = 0; i < 12; i++)
            {
                dateArry[i] = "";
            }
        }

        public string this[int i]
        {
            get
            {
                return dateArry[i - 1].Trim();  //i-1 means, from frontend, DateObj should be calculated for the months from 1 to 12, so if DateObj[1] should return date[0]. 
            }
            set
            {
                dateArry[i - 1] = value;
            }
        }
    }

    public class BalanceClass
    {
        private string[] balanceAmount;
        public BalanceClass()
        {
            balanceAmount = new string[12];
            for (int i = 0; i < 12; i++)
            {
                balanceAmount[i] = "";
            }
        }

        public string this[int i]
        {
            get
            {
                return balanceAmount[i - 1].Trim();  //i-1 means, from frontend, BalanceClassObj should be calculated for the months from 1 to 12, so if BalanceClassObj[1] should return balanceAmount[0]. 
            }
            set
            {
                balanceAmount[i - 1] = value;
            }
        }
    }
}