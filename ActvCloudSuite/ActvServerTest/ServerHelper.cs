using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Configuration;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;

namespace ActvServerTest
{
    public class ServerHelper
    {
        public static string AuthenticateServer()
        {
            string authenticateString = string.Empty;
            //User name, password, mac id for authentication
            string macId = "ApiRequestKey";
            string userName = "jaya";
            string password = "asd";
            string authenticateRoute = "token";

            userName = Encoder.Base64Encode(userName).Trim();
            password = Encoder.Base64Encode(password).Trim();
            macId = Encoder.Base64Encode(macId).Trim();

            HttpClient client = GetHttpClient();
            Assert.AreNotEqual(null, client);
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            //username=YW5hbmQ=&password=cGFzc3dvcmQ=&grant_type=password&mac=M2M6OTE6NTc6OTc6NzM6OWQ=
            string tokenString = string.Format("username={0}&password={1}&grant_type=password&mac={2}", userName, password, macId);

            HttpContent content = new StringContent(tokenString);

            HttpResponseMessage responseMessage = client.PostAsync(client.BaseAddress + authenticateRoute, content).Result;
            Assert.AreNotEqual(null, responseMessage);
            if (responseMessage.IsSuccessStatusCode)
            {
                string[] splitString = null;
                string responseData = responseMessage.Content.ReadAsStringAsync().Result;
                //sample response: {"access_token":"jjMVe7IqiRr6JDRuGlZi7TgwrG_RU6I2jDWpudf6A9GIDPtjqiyEEXkirPn6psIh_AZkzY2vDDTS_ffDYmKccBMGWfyX0weUKENbIVrwgAGWZe4QR54xugRu1nmHzredm8LccDr4fWZDgv0IliyohbKSj4NIkHqBtZjhfb7YIbzUS_H5p6ZZZRhothUfxJye4u6iX4Vpg1FKnVrD1K4cD0tUIMBpcFNKZ-vf_4K7uzI","token_type":"bearer","expires_in":86399}
                if (!string.IsNullOrWhiteSpace(responseData))
                {
                    splitString = responseData.Split(':');
                    if (splitString.Length > 1)
                    {
                        authenticateString = splitString[1].Replace("\"", "");
                        authenticateString = authenticateString.Replace(",token_type", "");
                    }
                }
            }

            return authenticateString;
        }

        public static HttpClient GetHttpClient()
        {
            string url = GetServerRootPath();
            HttpClient client = new HttpClient();
            client.BaseAddress = new Uri(url);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            client.Timeout = new TimeSpan(0, 5, 0);
            return client;
        }

        private static string GetServerRootPath()
        {
            return ConfigurationManager.AppSettings["ActvWebApiServerRootPath"];
        }

        private static HttpClient AuthenticateAndGetHttpClient()
        {
            string authenticateString = ServerHelper.AuthenticateServer();
            Assert.AreNotEqual(true, string.IsNullOrWhiteSpace(authenticateString));

            HttpClient client = GetHttpClient();
            Assert.AreNotEqual(null, client);
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", authenticateString);

            return client;
        }

        private static HttpClient AuthenticateAndGetHttpClient(string authenticateString)
        {
            Assert.AreNotEqual(true, string.IsNullOrEmpty(authenticateString));

            HttpClient client = GetHttpClient();
            Assert.AreNotEqual(null, client);
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", authenticateString);

            return client;
        }

        private static T ConvertResult<T>(HttpResponseMessage responseMessage)
        {
            T returnValue = default(T);
            string responseData = string.Empty;
            Assert.AreNotEqual(null, responseMessage);

            if (responseMessage.IsSuccessStatusCode)
            {
                responseData = responseMessage.Content.ReadAsStringAsync().Result;
                returnValue = JSonHelper.ConverJsonDatatToObj<T>(responseData);
            }
            Assert.AreNotEqual(null, returnValue);
            return returnValue;
        }

        public static T ExecuteRequest<T>(T list, string controllerName)
        {
            string postBody = JSonHelper.ConvertObjToJsonData(list);
            HttpClient client = AuthenticateAndGetHttpClient();
            HttpResponseMessage responseMessage = client.PostAsync(client.BaseAddress + "api/" + controllerName, new StringContent(postBody, Encoding.UTF8, "application/json")).Result;
            T result = ConvertResult<T>(responseMessage);
            return result;
        }

        public static T ExecuteRequest<T>(string list, string controllerName)
        {
            string postBody = JSonHelper.ConvertObjToJsonData(list);
            HttpClient client = AuthenticateAndGetHttpClient();
            HttpResponseMessage responseMessage = client.PostAsync(client.BaseAddress + "api/" + controllerName, new StringContent(postBody, Encoding.UTF8, "application/json")).Result;
            T result = ConvertResult<T>(responseMessage);
            return result;
        }

        public static T ExecuteGet<T>(string options, string controllerName)
        {
            HttpClient client = AuthenticateAndGetHttpClient();
            HttpResponseMessage responseMessage = client.GetAsync(client.BaseAddress + "api/" + controllerName + "?" + options).Result;
            T result = ConvertResult<T>(responseMessage);
            return result;
        }

        public static T ExecuteGet<T>(string options, string controllerName, string key)
        {
            HttpClient client = AuthenticateAndGetHttpClient(key);
            HttpResponseMessage responseMessage = client.GetAsync(client.BaseAddress + "api/" + controllerName + "?" + options).Result;
            T result = ConvertResult<T>(responseMessage);
            return result;
        }
    }


}
