
using Newtonsoft.Json;

namespace ActvServerTest
{
    public class JSonHelper
    {
        public static string ConvertObjToJsonData(object inputObj)
        {
            if (inputObj != null)
                return JsonConvert.SerializeObject(inputObj);
            else
                return string.Empty;
        }

        public static T ConverJsonDatatToObj<T>(string jsonData)
        {
            if (!string.IsNullOrEmpty(jsonData))
                return JsonConvert.DeserializeObject<T>(jsonData);
            else
                return default(T);
        }
    }
}
