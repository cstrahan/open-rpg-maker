using System;
using System.Threading;
using System.Windows;
using System.Windows.Threading;

namespace RMXPx
{
    public class Sync
    {
        public static Dispatcher Dispatcher { get; set; }

        static Sync()
        {
            Dispatcher = Deployment.Current.Dispatcher;
        }

        public static void Action(Action action)
        {
            if (Dispatcher.CheckAccess())
            {
                action();
                return;
            }

            var are = new AutoResetEvent(false);
            Dispatcher.BeginInvoke(
                () =>
                    {
                        try
                        {
                            action();
                        }
                        finally
                        {
                            are.Set();
                        }
                    }
                );
            are.WaitOne();
        }
    }
}