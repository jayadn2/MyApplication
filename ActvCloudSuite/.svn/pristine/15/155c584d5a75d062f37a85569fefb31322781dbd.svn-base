using ActvWebApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace ActvWebApi.HelperClasses
{
    public class UserValidationHelper
    {
        private static ActvEntities db = new ActvEntities();
        internal static bool ValidateUser(string userName, string id, string mac)
        {
            bool validated = false;
            if (!string.IsNullOrEmpty(userName) && !string.IsNullOrEmpty(id) && !string.IsNullOrEmpty(mac))
            {
                EmployeeTable employee = null;
                //string password = HelperClass.Base64Decode(id);
                login_info login = db.login_info.FirstOrDefault(l => l.username == userName && l.password == id);
                if (login != null) //User name and password match, now check for valid mobile mac id to restrict access from un-authorized mobiles.
                {
                    if (login.usertype.ToLower() == "admin")//Emp is admin
                    {
                        if (db.MobileInfoes.Count(m => m.IsActive) > 0) //If the admin user login is valid
                        {
                            validated = true;
                        }
                    }
                    else if(db.MobileInfoes.Count(m => m.EmpId == login.empid && m.MacId == mac && m.IsActive) > 0) //If the user login is valid
                    {
                        employee = db.EmployeeTables.FirstOrDefault(e => e.ID == login.empid);
                        validated = true;
                    }
                    //If different user is logged in from admin mobile, then we should allow it.
                    else
                    {
                        //Check if the mac id belongs to admin mobile
                        //1. Select the employees with admin rights
                        IEnumerable<login_info> adminLogins = db.login_info.Where(li => li.usertype.ToLower() == "admin");
                        if (adminLogins != null && adminLogins.Count() > 0)
                        {
                            //2. Check if the login mac id belongs to admin mobile
                            if (adminLogins.Any(al => db.MobileInfoes.Any(mi => mi.EmpId == al.empid && mi.MacId == mac)))
                                validated = true;
                        }
                    }
                }
            }
            return validated;
        }

        internal static async Task<string> GetUserEmpId(string userName)
        {
            string empId = string.Empty;
            int adminUser = 0;
            login_info login = db.login_info.FirstOrDefault(l => l.username == userName);
            if (login != null)
            {
                empId = login.empid.ToString();
                adminUser = IsAdminUser(login.empid.Value);
            }
            return empId + ";" + adminUser.ToString();
        }

        public static int IsAdminUser(int empId)
        {
            int adminUser = 0;
            if (db.login_info.Any(l => l.empid == empId && l.usertype.ToLower() == "admin"))
            {
                adminUser = 1;
            }
            return adminUser;
        }
    }
}