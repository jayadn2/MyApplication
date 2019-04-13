using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using ActvMvcClient.DynamicTableModels;
using ActvMvcClient.Models;
using System.Configuration;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Script.Serialization;
using System.Text;
using Newtonsoft.Json;
using System.Linq;

namespace ActvServerTest
{
    [TestClass]
    public class LedgerOpsUnitTest
    {
        //Test the web api connection
        public string ServerConnectionTestHelper()
        {
            string responseData = string.Empty;
            HttpClient client = ServerHelper.GetHttpClient();
            Assert.AreNotEqual(null, client);
            HttpResponseMessage responseMessage = client.GetAsync(client.BaseAddress + "api/orders").Result;
            Assert.AreNotEqual(null, responseMessage);
            if (responseMessage.IsSuccessStatusCode)
            {
                responseData = responseMessage.Content.ReadAsStringAsync().Result;
            }
            return responseData;
        }

        [TestMethod]
        public void ServerConnectionTest()
        {
            string serverResultData = ServerConnectionTestHelper();
            List<Order> testOrders = Order.CreateOrders();
            string testJsonData = JSonHelper.ConvertObjToJsonData(testOrders);
            Assert.AreEqual(testJsonData, serverResultData);
        }

        [TestMethod]
        public void ServerLoginTest()
        {
            string responseData = string.Empty;
            HttpClient client = ServerHelper.GetHttpClient();
            Assert.AreNotEqual(null, client);

            string authenticateString = string.Empty;
            //User name, password, mac id for authentication
            string macId = "ApiRequestKey";
            string userName = "jaya";
            string password = "asd";
            string authenticateRoute = "token";

            userName = Encoder.Base64Encode(userName).Trim();
            password = Encoder.Base64Encode(password).Trim();
            macId = Encoder.Base64Encode(macId).Trim();

            //client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                //username=YW5hbmQ=&password=cGFzc3dvcmQ=&grant_type=password&mac=M2M6OTE6NTc6OTc6NzM6OWQ=
                string tokenString = string.Format("username={0}&password={1}&grant_type=password&mac={2}", userName, password, macId);

                HttpContent content = new StringContent(tokenString);

                string path = client.BaseAddress + authenticateRoute;
            string tokenPath="http://www.simpfo.in/siti/token";

            HttpResponseMessage responseMessage = client.PostAsync(path, content).Result;//client.BaseAddress + authenticateRoute, content).Result;
                if (responseMessage != null)
                {
                    if (responseMessage.IsSuccessStatusCode)
                    {
                        string[] splitString = null;
                        string responseDatastr = responseMessage.Content.ReadAsStringAsync().Result;
                        //sample response: {"access_token":"jjMVe7IqiRr6JDRuGlZi7TgwrG_RU6I2jDWpudf6A9GIDPtjqiyEEXkirPn6psIh_AZkzY2vDDTS_ffDYmKccBMGWfyX0weUKENbIVrwgAGWZe4QR54xugRu1nmHzredm8LccDr4fWZDgv0IliyohbKSj4NIkHqBtZjhfb7YIbzUS_H5p6ZZZRhothUfxJye4u6iX4Vpg1FKnVrD1K4cD0tUIMBpcFNKZ-vf_4K7uzI","token_type":"bearer","expires_in":86399}
                        if (!string.IsNullOrWhiteSpace(responseDatastr))
                        {
                            splitString = responseDatastr.Split(':');
                            if (splitString.Length > 1)
                            {
                                authenticateString = splitString[1].Replace("\"", "");
                                authenticateString = authenticateString.Replace(",token_type", "");
                            }
                        }
                    }
                }
        }

        [TestMethod]
        public void UpdateLedgerTest()
        {
            LedgerOps ledgerOps = new LedgerOps();
            int custId = 5308;
            int amt = 100;
            int year = DateTime.Now.Year;
            DateTime billDate = DateTime.Today;
            int billNum = 11;
            CompanyTable company = new CompanyTable();
            company = company.GetCompanyForYear(year);
            int remAmt = ledgerOps.BeginUpdateLedger(custId, amt, company, billDate, billNum);
            Assert.AreEqual(0, remAmt);
        }

        [TestMethod]
        public void UpdatePrevYearLedgerTest()
        {
            LedgerOps ledgerOps = new LedgerOps();
            int custId = 5882;
            int amt = 100;
            int year = DateTime.Now.Year;
            DateTime billDate = DateTime.Today;
            int billNum = 12;
            CompanyTable company = new CompanyTable();
            company = company.GetCompanyForYear(year);
            int remAmt = ledgerOps.BeginUpdateLedger(custId, amt, company, billDate, billNum);
            Assert.AreEqual(0, remAmt);
        }

        [TestMethod]
        public void UpdatePrevYearLedger_WebApiTest()
        {           
            
            int custId = 5882;
            int amt = 100;
            int year = DateTime.Now.Year;
            DateTime billDate = DateTime.Today;
            int billNum = 12;
            int empId = 16;            

            LedgerEntry ledgerEntry = new LedgerEntry() { CustomerId = custId, Amount = amt, CompanyYear = year, BillDate=billDate, BillNum=billNum, EmpId=empId };
            List<LedgerEntry> ledgerEntriesList = new List<LedgerEntry>();
            ledgerEntriesList.Add(ledgerEntry);

            IList<LedgerEntry> returnValue = ServerHelper.ExecuteRequest<IList<LedgerEntry>>(ledgerEntriesList, "Ledger");
            Assert.AreNotEqual(null, returnValue);
            Assert.AreEqual(0, returnValue.Count);
        }

        [TestMethod]
        public void IsDuplicateLedgerEntry_WebApiTest()
        {
            int custId = 5882;
            int amt = 100;
            int year = DateTime.Now.Year;
            DateTime billDate = new DateTime(2013, 3, 13);
            int billNum = 14;
            int empId = 12;

            LedgerEntry ledgerEntry = new LedgerEntry() { CustomerId = custId, Amount = amt, CompanyYear = year, BillDate = billDate, BillNum = billNum, EmpId = empId };
            List<LedgerEntry> ledgerEntriesList = new List<LedgerEntry>();
            ledgerEntriesList.Add(ledgerEntry);

            ledgerEntry = new LedgerEntry() { CustomerId = custId, Amount = amt, CompanyYear = year, BillDate = new DateTime(2014,4,22), BillNum = 5787, EmpId = empId };
            ledgerEntriesList.Add(ledgerEntry);

            ledgerEntry = new LedgerEntry() { CustomerId = 5416, Amount = 50, CompanyYear = 2016, BillDate = new DateTime(2015, 4, 11), BillNum = 5107, EmpId = empId };
            ledgerEntriesList.Add(ledgerEntry);

            IList<LedgerEntry> returnValue = ServerHelper.ExecuteRequest<IList<LedgerEntry>>(ledgerEntriesList, "CheckDuplicateLedgerEntry");
            Assert.AreNotEqual(null, returnValue);
            Assert.AreEqual(ledgerEntriesList.Count, returnValue.Count);
        }

        [TestMethod]
        public void IsNotDuplicateLedgerEntry_WebApiTest()
        {
            int custId = 5882;
            int amt = 100;
            int year = DateTime.Now.Year;
            DateTime billDate = new DateTime(2013, 3, 13);
            int billNum = 19999;
            int empId = 12;

            LedgerEntry ledgerEntry = new LedgerEntry() { CustomerId = custId, Amount = amt, CompanyYear = year, BillDate = billDate, BillNum = billNum, EmpId = empId };
            List<LedgerEntry> ledgerEntriesList = new List<LedgerEntry>();
            ledgerEntriesList.Add(ledgerEntry);

            ledgerEntry = new LedgerEntry() { CustomerId = custId, Amount = amt, CompanyYear = year, BillDate = new DateTime(2014, 4, 22), BillNum = 1111, EmpId = empId };
            ledgerEntriesList.Add(ledgerEntry);

            ledgerEntry = new LedgerEntry() { CustomerId = 5416, Amount = 50, CompanyYear = 2016, BillDate = new DateTime(2015, 4, 11), BillNum = 2222, EmpId = empId };
            ledgerEntriesList.Add(ledgerEntry);

            IList<LedgerEntry> returnValue = ServerHelper.ExecuteRequest<IList<LedgerEntry>>(ledgerEntriesList, "CheckDuplicateLedgerEntry");
            Assert.AreNotEqual(null, returnValue);
            Assert.AreEqual(0, returnValue.Count);
        }
    }
}
