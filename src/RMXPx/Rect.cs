using System;
using System.Runtime.InteropServices;
using IronRuby.Builtins;
using IronRuby.Runtime;

namespace RMXPx
{
    [RubyClass("Rect")]
    public class Rect
    {
        public int X { get; set; }
        public int Y { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }

        public Rect()
        {
        }

        public Rect(int x, int y, int width, int height)
        {
            X = x;
            Y = y;
            Width = width;
            Height = height;
        }

        public Rect Intersect(Rect rect)
        {
            var intersect = new System.Windows.Rect(X, Y, Width, Height);
            var thatRect = new System.Windows.Rect(rect.X, rect.Y, rect.Width, rect.Height);
            intersect.Intersect(thatRect);
            return new Rect((int)intersect.X, (int)intersect.Y, (int)intersect.Width, (int)intersect.Height);
        }

        [RubyConstructor]
        public static Rect Create(RubyClass self, int x, int y, int width, int height)
        {
            return new Rect(x, y, width, height);
        }

        [RubyMethod("x")]
        public static int GetX(Rect self)
        {
            return self.X;
        }

        [RubyMethod("x=")]
        public static void SetX(Rect self, int x)
        {
            self.X = x;
        }

        [RubyMethod("y")]
        public static int GetY(Rect self)
        {
            return self.Y;
        }

        [RubyMethod("y=")]
        public static void SetY(Rect self, int y)
        {
            self.Y = y;
        }

        [RubyMethod("width")]
        public static int GetWidth(Rect self)
        {
            return self.Width;
        }

        [RubyMethod("width=")]
        public static void SetWidth(Rect self, int width)
        {
            self.Width = width;
        }

        [RubyMethod("height")]
        public static int GetHeight(Rect self)
        {
            return self.Height;
        }

        [RubyMethod("height=")]
        public static void SetHeight(Rect self, int height)
        {
            self.Height = height;
        }

        [RubyMethod("_dump")]
        public static MutableString Dump(
            ConversionStorage<IntegerValue>/*!*/ integerConversion,
            ConversionStorage<double>/*!*/ floatConversion,
            ConversionStorage<MutableString>/*!*/ stringCast,
            ConversionStorage<MutableString>/*!*/ tosConversion,
            Rect self,
            [Optional]int? aDepth)
        {
            var array = new RubyArray(new[] { self.X, self.Y, self.Width, self.Height });
            return ArrayOps.Pack(integerConversion, floatConversion, stringCast, tosConversion, array, MutableString.Create("d4", RubyEncoding.Ascii));
        }

        [RubyMethod("_load", RubyMethodAttributes.PublicSingleton)]
        public static Rect Load(RubyClass self, MutableString input)
        {
            var format = MutableString.Create("d4", RubyEncoding.Ascii);
            var array = MutableStringOps.Unpack(input, format);
            var x = Convert.ToInt32(array[0]);
            var y = Convert.ToInt32(array[1]);
            var width = Convert.ToInt32(array[2]);
            var height = Convert.ToInt32(array[3]);

            return new Rect(x, y, width, height);
        }
    }
}