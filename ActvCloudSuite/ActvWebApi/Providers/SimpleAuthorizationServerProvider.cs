using ActvWebApi.AuthenticationHelper;
using ActvWebApi.HelperClasses;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security.OAuth;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;

namespace ActvWebApi.Providers
{
    public class SimpleAuthorizationServerProvider : OAuthAuthorizationServerProvider
    {
        string mac = string.Empty;
        public override async Task ValidateClientAuthentication(OAuthValidateClientAuthenticationContext context)
        {
            mac = HelperClass.Base64Decode(context.Parameters["mac"]);
            context.Validated();
        }

        public override async Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
        {

            context.OwinContext.Response.Headers.Add("Access-Control-Allow-Origin", new[] { "*" });            

            string userName= HelperClass.Base64Decode(context.UserName);
            string password = HelperClass.Base64Decode(context.Password);
            using (AuthRepository _repo = new AuthRepository())
            {
                IdentityUser user = await _repo.FindUser(userName, password, mac);

                if (user == null)
                {
                    context.SetError("invalid_grant", "The user name or password is incorrect.");
                    return;
                }
                string empId = await UserValidationHelper.GetUserEmpId(userName);
                empId = HelperClass.Base64Encode(empId);
                context.OwinContext.Response.Headers.Add("ed", new[] { empId });
            }

            var identity = new ClaimsIdentity(context.Options.AuthenticationType);
            identity.AddClaim(new Claim("sub", userName));
            identity.AddClaim(new Claim("role", "user"));

            context.Validated(identity);

        }

        public override Task MatchEndpoint(OAuthMatchEndpointContext context)
        {
            Task t= base.MatchEndpoint(context);
            //return base.MatchEndpoint(context);
            return t;
        }
    }
}