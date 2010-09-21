using System.Runtime.InteropServices;
using IronRuby.Builtins;
using IronRuby.Runtime;
using Microsoft.Scripting.Runtime;

namespace RMXPx
{
    //class Font
    //  attr_accessor :name, :size, :bold, :italic, :color

    //  # Creates a Font object.
    //  def initialize(name=nil, size=nil)
    //    @name = name || Font.default_name
    //    @size = size || Font.default_size
    //    @bold = Font.default_bold
    //    @italic = Font.default_italic
    //    @color = Font.default_color
    //  end

    //  # Returns TRUE when the specified font exists within the system.
    //  def self.exist?(name)
    //    raise "not implemented"
    //  end

    //  # Defaults
    //  @default_name = "MS PGothic"
    //  @default_size = 22
    //  @default_bold = false
    //  @default_italic = false
    //  @default_color = Color.new(255,255,255,255)

    //  class << self
    //    attr_accessor :default_name, :default_size, :default_bold, :default_italic, :default_color
    //  end
    //end

    [RubyClass("Font", Extends = typeof(Font))]
    public class FontOps
    {
        [RubyConstructor]
        public static Font Create(RubyClass/*!*/ self, [DefaultProtocol, Optional]string name, [DefaultProtocol, Optional]int? size)
        {
            var font = Font.GetDefaultCopy(self.Context);

            if (name != null)
            {
                font.Name = name;
            }
            if (size != null)
            {
                font.Size = size.Value;
            }

            return font;
        }

        [RubyMethod("name", RubyMethodAttributes.PublicInstance)]
        public static string GetName(Font/*!*/ self)
        {
            return self.Name;
        }

        [RubyMethod("size", RubyMethodAttributes.PublicInstance)]
        public static int GetSize(Font/*!*/ self)
        {
            return self.Size;
        }

        [RubyMethod("bold", RubyMethodAttributes.PublicInstance)]
        public static bool GetBold(Font/*!*/ self)
        {
            return self.Bold;
        }

        [RubyMethod("italic", RubyMethodAttributes.PublicInstance)]
        public static bool GetItalic(Font/*!*/ self)
        {
            return self.Italic;
        }

        [RubyMethod("color", RubyMethodAttributes.PublicInstance)]
        public static Color GetColor(Font/*!*/ self)
        {
            return self.Color;
        }


        [RubyMethod("name=", RubyMethodAttributes.PublicInstance)]
        public static void SetName(Font/*!*/ self, string name)
        {
             self.Name = name;
        }

        [RubyMethod("size=", RubyMethodAttributes.PublicInstance)]
        public static void SetSize(Font/*!*/ self, int size)
        {
             self.Size = size;
        }

        [RubyMethod("bold=", RubyMethodAttributes.PublicInstance)]
        public static void SetBold(Font/*!*/ self, bool bold)
        {
            self.Bold = bold;
        }

        [RubyMethod("italic=", RubyMethodAttributes.PublicInstance)]
        public static void SetItalic(Font/*!*/ self, bool italic)
        {
             self.Italic = italic;
        }

        [RubyMethod("color=", RubyMethodAttributes.PublicInstance)]
        public static void SetColor(Font/*!*/ self, Color color)
        {
             self.Color = color;
        }


        // attr_accessor :default_name, :default_size, :default_bold, :default_italic, :default_color
        [RubyMethod("default_name", RubyMethodAttributes.PublicSingleton)]
        public static string GetDefaultName(RubyClass/*!*/ self)
        {
            return Font.GetDefaultSingleton(self.Context).Name;
        }

        [RubyMethod("default_size", RubyMethodAttributes.PublicSingleton)]
        public static int GetDefaultSize(RubyClass/*!*/ self)
        {
            return Font.GetDefaultSingleton(self.Context).Size;
        }

        [RubyMethod("default_bold", RubyMethodAttributes.PublicSingleton)]
        public static bool GetDefaultBold(RubyClass/*!*/ self)
        {
            return Font.GetDefaultSingleton(self.Context).Bold;
        }

        [RubyMethod("default_italic", RubyMethodAttributes.PublicSingleton)]
        public static bool GetDefaultItalic(RubyClass/*!*/ self)
        {
            return Font.GetDefaultSingleton(self.Context).Italic;
        }

        [RubyMethod("default_color", RubyMethodAttributes.PublicSingleton)]
        public static Color GetDefaultColor(RubyClass/*!*/ self)
        {
            return Font.GetDefaultSingleton(self.Context).Color;
        }


        [RubyMethod("default_name=", RubyMethodAttributes.PublicSingleton)]
        public static void SetDefaultName(RubyClass/*!*/ self, string name)
        {
            Font.GetDefaultSingleton(self.Context).Name = name;
        }

        [RubyMethod("default_size=", RubyMethodAttributes.PublicSingleton)]
        public static void SetDefaultSize(RubyClass/*!*/ self, int size)
        {
            Font.GetDefaultSingleton(self.Context).Size = size;
        }

        [RubyMethod("default_bold=", RubyMethodAttributes.PublicSingleton)]
        public static void SetDefaultBold(RubyClass/*!*/ self, bool bold)
        {
            Font.GetDefaultSingleton(self.Context).Bold = bold;
        }

        [RubyMethod("default_italic=", RubyMethodAttributes.PublicSingleton)]
        public static void SetDefaultItalic(RubyClass/*!*/ self, bool italic)
        {
            Font.GetDefaultSingleton(self.Context).Italic = italic;
        }

        [RubyMethod("default_color=", RubyMethodAttributes.PublicSingleton)]
        public static void SetDefaultColor(RubyClass/*!*/ self, Color color)
        {
            Font.GetDefaultSingleton(self.Context).Color = color;
        }
    }
}