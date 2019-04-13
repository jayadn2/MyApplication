using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(ActvMvcClient.Startup))]
namespace ActvMvcClient
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
