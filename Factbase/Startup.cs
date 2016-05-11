using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Factbase.Startup))]
namespace Factbase
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
