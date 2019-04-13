using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;

namespace ActvWebApi
{
    public class HelperClass
    {
        private static DateComparer dateComparer = new DateComparer();
        public static string Base64Encode(string plainText)
        {
            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(plainText);
            return System.Convert.ToBase64String(plainTextBytes);
        }

        public static string Base64Decode(string base64EncodedData)
        {
            var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
            return System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
        }

        public static string InsertDateFormat
        {
            get
            {
                return "dd/MM/yyyy";
            }
            //.ToString("dd/MM/yyyy",CultureInfo.CurrentCulture)
        }

        public static string ConvertDateToInsertFormat(DateTime sourceDate)
        {
            return sourceDate.ToString(InsertDateFormat, new CultureInfo("en-IN"));//CultureInfo.InvariantCulture);//en-IN
        }

        public static string InterChangeDateMonth(string dateValue, char separator)
        {
            if (!string.IsNullOrEmpty(dateValue))
            {
                string[] dateArr = dateValue.Split(separator);
                if (dateArr.Length == 3)
                    dateValue = dateArr[1] + separator + dateArr[0] + separator + dateArr[2];
                return dateValue;
            }
            else
                return string.Empty;
        }

        public static bool CompareDateStrings(DateTime src, DateTime dst)
        {
            return dateComparer.CompareDateStrings(src, dst);
        }

        public static bool CompareDateStrings(string dateSrc, string dateDst)
        {
            return dateComparer.CompareDateStrings(dateSrc, dateDst);
        }

        public static string[] ConvertDateStrToArrya(string dateString)
        {
            //Normalize separators in the string
            dateString = dateString.Replace('/', '-');
            string[] tmpDateArray = dateString.Split('-');
            string[] result = new string[tmpDateArray.Length / 3];
            for (int i = 0, j = 0; i < tmpDateArray.Length; i++)
            {
                if (i % 3 == 0)
                {
                    result[j++] = tmpDateArray[i] + "-" + tmpDateArray[i + 1] + "-" + tmpDateArray[i + 2];
                }
            }

            return result;
        }

        public static string RemoveDuplicateEntryFromLedgerEntry(string entryToRemove, string srcEntry, out int index, bool isDateField = false)
        {
            //When comparing dates, make the separators equal
            entryToRemove = entryToRemove.Replace('/', '-');
            srcEntry = srcEntry.Replace('/', '-');
            //Case: entryToRemove = 308, srcEntry = 1. 308 2. 308-100 3. 100-308 4. 100-308-200
            string modStr = string.Empty;
            entryToRemove = entryToRemove.Trim();
            string[] srcSplitArry = srcEntry.Split('-');
            index = 0;
            //Case 1: If entryToRemove = 308 and srcEntry = 308
            if (srcSplitArry.Length == 1)
                return string.Empty;
            else
            {
                //Case 2: If entryToRemove = 308 and srcEntry = 308-100   

                for (int i = 0; i < srcSplitArry.Length; i++)
                {
                    string str = srcSplitArry[i];
                    string tmpStr = str.Trim();
                    if (isDateField)
                    {
                        if (!CompareDateStrings(entryToRemove, tmpStr))
                            modStr = tmpStr + "-";
                        else
                        {
                            index = i;
                        }
                    }
                    else
                    {
                        if (entryToRemove != tmpStr)
                            modStr = tmpStr + "-";
                        else
                        {
                            index = i;
                        }
                    }
                }
                //If '-' is added at the end and there is no entry after that, remove the '-'
                modStr = RemoveTrailingDash(modStr);

            }
            return modStr;
        }

        private static string RemoveTrailingDash(string modStr)
        {
            //If '-' is added at the end and there is no entry after that, remove the '-'
            if (modStr.Length > 0)
            {
                if (modStr[modStr.Length - 1] == '-')
                    modStr = modStr.Remove(modStr.Length - 1, 1);
            }
            return modStr;
        }

        public static string RemoveDuplicateEntryFromLedgerEntryOnIndex(string srcEntry, int index, out string removedEntry, bool isDate = false)
        {
            string modStr = string.Empty;
            string[] tmpArr = null;
            removedEntry = string.Empty;
            if (isDate)
            {
                tmpArr = ConvertDateStrToArrya(srcEntry);
            }
            else
            {
                tmpArr = srcEntry.Split('-');
            }

            if (tmpArr != null)
            {
                for (int i = 0; i < tmpArr.Length; i++)
                {
                    if (index != i)
                    {
                        modStr = tmpArr[i] + "-";
                    }
                    else
                    {
                        removedEntry = tmpArr[i];
                    }
                }
            }
            modStr = RemoveTrailingDash(modStr);
            return modStr;
        }

        public static string ConcatenateString(string inputStr, string conStr)
        {
            string separator = " - ";
            //If input string = 'np', remove it.
            if (inputStr.ToLowerInvariant().Trim() == "np")
            {
                inputStr = string.Empty;
            }
            if (string.IsNullOrWhiteSpace(inputStr.Trim()))
            {
                inputStr = conStr;
            }
            else
            {
                inputStr += separator + conStr;
            }
            return inputStr;
        }

        public static string GetEnumEname<T>(T enumVal)
        {
            return Enum.GetName(typeof(T), enumVal);
        }
    }
}