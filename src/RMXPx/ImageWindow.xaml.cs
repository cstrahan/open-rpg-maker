using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;

namespace RMXPx
{
    public partial class ImageWindow : ChildWindow
    {
        public ImageWindow()
        {
            InitializeComponent();
        }

        public static ImageWindow Show(ImageSource source)
        {
            var window = new ImageWindow();
            window.Image.Source = source;
            window.Show();
            return window;
        }

        public static void ShowDialog(ImageSource source)
        {
            var waitHandle = new AutoResetEvent(false);

            Sync.Dispatcher.BeginInvoke(() =>
            {
                var window = new ImageWindow();
                window.Image.Source = source;
                window.Closed += delegate { waitHandle.Set(); };
                window.Show();
            });

            waitHandle.WaitOne();
        }

        private void OKButton_Click(object sender, RoutedEventArgs e)
        {
            this.DialogResult = true;
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            this.DialogResult = false;
        }
    }
}

