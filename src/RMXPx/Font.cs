using IronRuby.Builtins;
using IronRuby.Runtime;

namespace RMXPx
{
    public class Font
    {
        public string Name { get;  set; }
        public int Size { get;  set; }
        public bool Bold { get;  set; }
        public bool Italic { get;  set; }
        public Color Color { get;  set; }

        private static Font GetDefaultFontInternal(RubyContext context)
        {
            object var;
            RubyClass fontClass = context.GetClass(typeof (Font));
            if (!fontClass.TryGetClassVariable("default_font", out var))
            {
                var = new Font
                          {
                              Name = "Arial",
                              Size = 22,
                              Bold = false,
                              Italic = false,
                              Color = new Color(255, 255, 255, 255),
                          };
                fontClass.SetClassVariable("default_font", var);
            }

            return (Font) var;
        }

        public static bool FontExists(string name)
        {
            // TODO: Implement this
            return true;
        }

        public static Font GetDefaultSingleton(RubyContext context)
        {
            Font defaultFont = GetDefaultFontInternal(context);
            return defaultFont;
        }

        public static Font GetDefaultCopy(RubyContext context)
        {
            Font defaultFont = GetDefaultFontInternal(context);
            return new Font
                       {
                           Name = defaultFont.Name,
                           Size = defaultFont.Size,
                           Bold = defaultFont.Bold,
                           Italic = defaultFont.Italic,
                           Color = defaultFont.Color
                       };
        }
    }
}