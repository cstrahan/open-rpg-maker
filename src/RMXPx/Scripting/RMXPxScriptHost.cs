using Microsoft.Scripting;
using Microsoft.Scripting.Hosting;

namespace RMXPx.Scripting
{
    public class RMXPxScriptHost : ScriptHost
    {
        private PlatformAdaptationLayer _pal;

        public RMXPxScriptHost()
        {
            _pal = new SilverlightPAL();
        }

        public override PlatformAdaptationLayer PlatformAdaptationLayer
        {
            get
            {
                return _pal;
            }
        }
    }
}