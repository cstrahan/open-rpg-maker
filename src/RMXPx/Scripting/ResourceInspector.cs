using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace RMXPx.Scripting
{
    public class ResourceInspector
    {
        public static IDictionary<String, Uri> Inspect(Assembly assembly)
        {
            if (assembly == null)
            {
                throw new ArgumentNullException("assembly");
            }

            var uriLookup = new Dictionary<string, Uri>(StringComparer.OrdinalIgnoreCase);

            var asmName = assembly.FullName.Split(new[] { ',' })[0]; // Can't use assembly.GetName().Name in SL . . .
            var resourceNames =
                assembly.GetManifestResourceNames().Select(
                    name => name.Replace(".resources", ""));
            var resourceManagers = resourceNames.Select(name => new System.Resources.ResourceManager(name, assembly));

            foreach (var resourceManager in resourceManagers)
            {
                var dummy = resourceManager.GetStream("__dummy__"); // Need to do this, otherwise next line will fail...
                var rs = resourceManager.GetResourceSet(Thread.CurrentThread.CurrentUICulture, false, true);
                IDictionaryEnumerator enumerator = rs.GetEnumerator();
                while (enumerator.MoveNext())
                {
                    // We can also do this:
                    // var stream = (Stream)enumerator.Value;

                    var resourceName = (string)enumerator.Key;
                    var uri = new Uri(asmName + ";component/" + resourceName, UriKind.Relative);
                    uriLookup[resourceName] = uri;
                }
            }

            return uriLookup;
        }
    }
}