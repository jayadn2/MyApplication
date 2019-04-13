using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;

namespace ActvServerTest
{
    [TestClass]
    public class SoftLandLedgerUnitTest
    {
        [TestMethod]
        public void UpdatePrevYearSoftLandLedger_WebApiTest()
        {

            string authenticateString = ServerHelper.AuthenticateServer();
            Assert.AreNotEqual(true, string.IsNullOrWhiteSpace(authenticateString));
            int custId = 5882;
            int amt = 100;
            int year = DateTime.Now.Year;
            DateTime billDate = DateTime.Today;
            int billNum = 12;
            int empId = 16;
            string agentCode = "7";
            int transactId = 99;

            string responseData = string.Empty;
            HttpClient client = ServerHelper.GetHttpClient();
            Assert.AreNotEqual(null, client);

            SoftLandLedgerEntry ledgerEntry = new SoftLandLedgerEntry() { CustomerId = custId, Amount = amt, CompanyYear = year, BillDate = billDate, BillNum = billNum, EmpId = empId, TransactId = transactId, AgentCode = agentCode };
            List<SoftLandLedgerEntry> ledgerEntriesList = new List<SoftLandLedgerEntry>();
            ledgerEntriesList.Add(ledgerEntry);
            string postBody = JSonHelper.ConvertObjToJsonData(ledgerEntriesList);

            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", authenticateString);

            HttpResponseMessage responseMessage = client.PostAsync(client.BaseAddress + "api/SoftLandBilling", new StringContent(postBody, Encoding.UTF8, "application/json")).Result;
            Assert.AreNotEqual(null, responseMessage);
            IList<SoftLandLedgerEntry> returnValue = null;
            if (responseMessage.IsSuccessStatusCode)
            {
                responseData = responseMessage.Content.ReadAsStringAsync().Result;
                returnValue = JSonHelper.ConverJsonDatatToObj<IList<SoftLandLedgerEntry>>(responseData);
            }
            Assert.AreNotEqual(null, returnValue);
            Assert.AreEqual(0, returnValue.Count);
        }
    }
}
