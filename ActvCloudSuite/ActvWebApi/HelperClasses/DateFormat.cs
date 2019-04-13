using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ActvWebApi
{
    public class DateFormat
    {
        public static string AppDateFormat
        {
            get
            {
                return "dd/MM/yyyy";
            }
        }

        public static string FormatDateBeforeConversion(string inputDate)
        {
            string outputDate = inputDate;
            string dateSparator = "/";
            string[] dateComponents = outputDate.Split('/');
            if(dateComponents.Length == 3)
            {
                //Convert to dd format
                if (dateComponents[0].Length == 1)
                    dateComponents[0] = "0" + dateComponents[0];
                //Convert to MM format
                if (dateComponents[1].Length == 1)
                    dateComponents[1] = "0" + dateComponents[1];
                outputDate = dateComponents[0] + dateSparator + dateComponents[1] + dateSparator + dateComponents[2];
            }
            return outputDate;
        }
    }
}