using System;
using System.IO;
using System.Net;
using System.Threading;
using System.Windows;
using System.Windows.Browser;

namespace RMXPx.Scripting
{
    public static class WebXapFileLoader
    {
        private static bool IsXapServedByWebServer()
        {
            Uri originalUrl = HtmlPage.Document.DocumentUri;
            return !string.Equals(originalUrl.Scheme, "file", StringComparison.OrdinalIgnoreCase);
        }


        public static void Load(Action<Stream> callback)
        {
            if (!IsXapServedByWebServer())
            {
                throw new InvalidOperationException("XAP must be served by a web server.");
            }

            Uri originalUrl = HtmlPage.Document.DocumentUri;
            string xapFile = (string)HtmlPage.Plugin.GetProperty("source");
            if (xapFile == null)
                throw new Exception("Could not get xap source");
            Uri xapLocation = new Uri(originalUrl, xapFile);

            WebClient client = new WebClient();
            client.OpenReadCompleted += (sender, e) => callback(e.Result);
            client.OpenReadAsync(xapLocation);
        }

        public static void Load(Uri xapUri, Action<Stream> callback)
        {
            WebClient client = new WebClient();
            client.OpenReadCompleted += (sender, e) => callback(e.Result);
            client.OpenReadAsync(xapUri);
        }
    }
}