using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Threading;
using System.Windows;
using System.Windows.Browser;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using IronRuby.Builtins;
using IronRuby.Runtime;
using Microsoft.Scripting.Hosting;
using Microsoft.Scripting.Hosting.Providers;
using Microsoft.Scripting.Silverlight;
using System.Windows.Resources;
using RMXPx.Scripting;
using XapVirtualFilesystem = RMXPx.Scripting.XapVirtualFilesystem;

namespace RMXPx
{
    public partial class App : Application
    {

        public App()
        {
            RubyUtils.FileSystemUsesDriveLetters = false;

            this.Startup += this.Application_Startup;
            this.Exit += this.Application_Exit;
            this.UnhandledException += this.Application_UnhandledException;

            InitializeComponent();
        }

        private ScriptRuntimeSetup GetSetup()
        {
            var setup = new ScriptRuntimeSetup();
            


            // Standard options
            var typeName = typeof(RubyContext).AssemblyQualifiedName;
            string displayName = "IronRuby";
            var names = new[] { "IronRuby", "Ruby", "rb" }.ToList();
            var exts = new List<string> { ".rb" };

            //// Remove any existing Ruby LanguageSetups
            ////var languageSetup =
            ////    setup.LanguageSetups.SingleOrDefault(s => s.DisplayName == "IronRuby") ??
            ////    setup.LanguageSetups.First(s => names.Union(s.Names).Count() > 0);
            ////setup.LanguageSetups.Remove(languageSetup);
            
            //setup.HostType = typeof(BrowserScriptHost);
            setup.DebugMode = true;
            setup.HostType = typeof(RMXPxScriptHost);
            setup.LanguageSetups.Add(new LanguageSetup(typeName, displayName, names, exts));

            // enable tracing
            //setup.Options.Add("EnableTracing", true); 

            return setup;
        }

        private void Application_Startup(object sender, StartupEventArgs e)
        {
            
            //var resources = ResourceInspector.Inspect(Assembly.GetExecutingAssembly());
            //foreach (var resource in resources)
            //{
            //    MessageBox.Show(resource.Key);
            //} 

            //WebXapFileLoader.Load(stream =>
            //                          {
            //                              var filenames = XapInspector.GetFileNames(stream);
            //                              foreach (var filename in filenames)
            //                              {
            //                                  var streamInfo = Application.GetResourceStream(new Uri(filename, UriKind.Relative));
            //                              }
            //                          });


            //XapVirtualFilesystem vfs = new XapVirtualFilesystem();
            //var uri = XapVirtualFilesystem.TryGetMainXapUri();
            //vfs.XapContentLoaded += (s, args) =>
            //                            {

            //                            };
            //vfs.Load(uri);

            // -------

            var main = new MainPage();
            var bmp = new WriteableBitmap(640, 480);
            bmp.Clear(System.Windows.Media.Color.FromArgb(255, 0, 0, 0));
            //bmp.Clear(Colors.White);
            main.image.ImageSource = bmp;
            this.RootVisual = main;
           
            // Set up scripting host
            var setup = GetSetup();
            var runtime = IronRuby.Ruby.CreateRuntime(setup);
            var engine = runtime.GetEngine("rb");
            var context = (RubyContext)HostingHelpers.GetLanguageContext(engine);
            var scope = engine.CreateScope();

            // Push path
            var searchPaths = engine.GetSearchPaths().ToList();
            searchPaths.Add("rb");
            searchPaths.AddRange(new []{"/lib/IronRuby","/lib/ruby/site_ruby/1.8" , "/lib/ruby/site_ruby", "/lib/ruby/1.8"});
            engine.SetSearchPaths(searchPaths);

            // Load assemblies
            //runtime.LoadAssembly(Assembly.GetExecutingAssembly()); // This does NOT load the library initializer!!!
            LoadRubyLib(context, Assembly.GetExecutingAssembly());

            // TESTING: make the bitmap available
            scope.SetVariable("bmp", new Bitmap(bmp, Font.GetDefaultCopy(context)));
            scope.SetVariable("msgbox", new Action<string>(s => MessageBox.Show(s)));

            Graphics.SetSurfaceBmp(context.GetClass(typeof(Graphics)), new Bitmap(bmp, Font.GetDefaultCopy(context)));
            
            // Insert REPL into DOM
            // HACK: need to load Microsoft.Scripting assembly
            //runtime.LoadAssembly(typeof(BrowserPAL).Assembly);
            //runtime.LoadAssembly(typeof(System.Windows.MessageBox).Assembly);
            //HtmlElement replDiv;
            //var repl = Repl.Create(engine, scope, out replDiv);
            //HtmlPage.Document.Body.AppendChild(replDiv);
            //repl.Start();
            //context.StandardOutput = repl.OutputBuffer;
            //context.StandardErrorOutput = repl.OutputBuffer;

            
                               if (context.Platform is SilverlightPAL)
                               {
                                   var vfs = ((SilverlightPAL) context.Platform).XapFileSystem;
                                   var stdUri = new Uri(HtmlPage.Document.DocumentUri,
                                                        new Uri("./StandardRTP.zip", UriKind.Relative));
                                   var rubylib = new Uri(HtmlPage.Document.DocumentUri,
                                                         new Uri("./rubylib.zip", UriKind.Relative));
                                   var gameUri = new Uri(HtmlPage.Document.DocumentUri,
                                                         new Uri("./game.zip", UriKind.Relative));
                                   vfs.Load(new[] {rubylib, stdUri, gameUri, XapVirtualFilesystem.TryGetMainXapUri()},
                                            () =>
                                                {
                                                    new Thread(() =>
                                                                   {
                                                                       // Load the game scripts
                                                                       string startScript =
                                                                           @"

#$CALL_DEPTH = 0
#p = proc { |op, file, line, method, b, cls|
#    if op == ""call""
#      filename = file.nil? ? nil : file.gsub('\\','/')
#      puts ""#{$CALL_DEPTH}\t"" + ('| ' * $CALL_DEPTH) + ""> #{cls}::#{method} #{filename}:#{line}""
#      locals = eval(""local_variables"", b)
#      local_values = locals.each { |l|
#        val = nil
#        begin
#          val = eval(l, b)
#        rescue
#        end
#        puts ""#{$CALL_DEPTH}\t"" + ('| ' * $CALL_DEPTH) + "" #{l}:#{val.inspect}""
#      }
#      $CALL_DEPTH += 1
#    elsif op == ""return""
#      $CALL_DEPTH -= 1 if $CALL_DEPTH > 0
#    elsif op == ""raise""
#      puts ""$!"" * 20
#    end
#}



    

#set_trace_func p

begin
  require 'rpg'

  # My tests
  sprite = Sprite.new(Viewport.new(10, 10, 50, 50))
  sprite.viewport.z = 100000
  sprite.viewport.color = Color.new(255,255,255,120)
  sprite.viewport.rect.x = 0
  sprite.bitmap = Bitmap.new(640,480)
  sprite.bitmap.draw_text(0, 0, 640, 30, 
  ""a b c d e f g h j k l m n o p q r s t"",
  0)
  sprite.z = 100000


  require 'zlib'
  database = File.open('Data/Scripts.rxdata', 'rb') { |f| Marshal.load f }
  
  database.each do |script|
    script_name = script[1]
    script = Zlib::Inflate.inflate(script[2])
    
    eval(script, binding, script_name)
  end
rescue Exception => ex
  msgbox.call(ex)
end";
                                                                       var foo = vfs;
                                                                       engine.Execute(startScript);
                                                                   }).Start();
                                                });
                               }
                           
        }


        // Does the same thing Kernel.load_assembly does (calls LibraryInitializer)
        public static void LoadRubyLib(RubyContext context, Assembly assembly)
        {
            var assemblyName = assembly.FullName;
            var libraryNamespace = assemblyName.Substring(0, assemblyName.IndexOf(','));

            var initializer = LibraryInitializer.GetFullTypeName(libraryNamespace);
            context.Loader.LoadAssembly(Assembly.GetExecutingAssembly().FullName, initializer, true, true);
        }

        public void MsgBox(string str)
        {
            MessageBox.Show(str);
        }

        private void Application_Exit(object sender, EventArgs e)
        {

        }

        private void Application_UnhandledException(object sender, ApplicationUnhandledExceptionEventArgs e)
        {
            // If the app is running outside of the debugger then report the exception using
            // the browser's exception mechanism. On IE this will display it a yellow alert 
            // icon in the status bar and Firefox will display a script error.
            if (!System.Diagnostics.Debugger.IsAttached)
            {

                // NOTE: This will allow the application to continue running after an exception has been thrown
                // but not handled. 
                // For production applications this error handling should be replaced with something that will 
                // report the error to the website and stop the application.
                e.Handled = true;
                Deployment.Current.Dispatcher.BeginInvoke(delegate { ReportErrorToDOM(e); });
            }
        }

        private void ReportErrorToDOM(ApplicationUnhandledExceptionEventArgs e)
        {
            try
            {
                string errorMsg = e.ExceptionObject.Message + e.ExceptionObject.StackTrace;
                errorMsg = errorMsg.Replace('"', '\'').Replace("\r\n", @"\n");

                System.Windows.Browser.HtmlPage.Window.Eval("throw new Error(\"Unhandled Error in Silverlight Application " + errorMsg + "\");");
            }
            catch (Exception)
            {
            }
        }
    }
}
