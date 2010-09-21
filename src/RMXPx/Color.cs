using System;
using System.Runtime.InteropServices;
using IronRuby.Builtins;
using IronRuby.Runtime;

namespace RMXPx
{
    [RubyClass("Color")]
    public class Color
    {
        private int _red;
        private int _green;
        private int _blue;
        private int _alpha;

        public int Red
        {
            get
            {
                return _red;
            }
            set
            {
                _red = ConstrainChannel(value);
            }
        }

        public int Green
        {
            get
            {
                return _green;
            }
            set
            {
                _green = ConstrainChannel(value);
            }
        }

        public int Blue
        {
            get
            {
                return _blue;
            }
            set
            {
                _blue = ConstrainChannel(value);
            }
        }

        public int Alpha
        {
            get
            {
                return _alpha;
            }
            set
            {
                _alpha = ConstrainChannel(value);
            }
        }

        public Color()
        {
        }

        public Color(int red, int green, int blue, int alpha)
        {
            Red = red;
            Green = green;
            Blue = blue;
            Alpha = alpha;
        }

        public override string ToString()
        {
            return ("#" +
                   Convert.ToString(Alpha, 16) +
                   Convert.ToString(Red, 16) +
                   Convert.ToString(Green, 16) +
                   Convert.ToString(Blue, 16)).ToUpper();
        }

        public static int ConstrainChannel(int value)
        {
            if (value < 0)
            {
                return 0;
            }
            else if (value > 255)
            {
                return 255;
            }

            return value;
        }

        [RubyConstructor]
        public static Color Create(RubyClass self, int red, int green, int blue, [Optional]int? alpha)
        {
            return new Color(red, green, blue, alpha ?? 255);
        }

        [RubyMethod("red")]
        public static int GetRed(Color self)
        {
            return self.Red;
        }

        [RubyMethod("red=")]
        public static void SetRed(Color self, int red)
        {
            self.Red = red;
        }

        [RubyMethod("green")]
        public static int GetGreen(Color self)
        {
            return self.Green;
        }

        [RubyMethod("green=")]
        public static void SetGreen(Color self, int green)
        {
            self.Green = green;
        }

        [RubyMethod("blue")]
        public static int GetBlue(Color self)
        {
            return self.Blue;
        }

        [RubyMethod("blue=")]
        public static void SetBlue(Color self, int blue)
        {
            self.Blue = blue;
        }

        [RubyMethod("alpha")]
        public static int GetAlpha(Color self)
        {
            return self.Alpha;
        }

        [RubyMethod("alpha=")]
        public static void SetAlpha(Color self, int alpha)
        {
            self.Alpha = alpha;
        }


        [RubyMethod("_dump")]
        public static MutableString Dump(
            ConversionStorage<IntegerValue>/*!*/ integerConversion,
            ConversionStorage<double>/*!*/ floatConversion,
            ConversionStorage<MutableString>/*!*/ stringCast,
            ConversionStorage<MutableString>/*!*/ tosConversion,
            Color self,
            [Optional]int? aDepth)
        {
            var array = new RubyArray(new[] { self.Red, self.Green, self.Blue, self.Alpha });
            return ArrayOps.Pack(integerConversion, floatConversion, stringCast, tosConversion, array, MutableString.Create("d4", RubyEncoding.Ascii));
        }

        [RubyMethod("_load", RubyMethodAttributes.PublicSingleton)]
        public static Color Load(RubyClass self, MutableString input)
        {
            var format = MutableString.Create("d4", RubyEncoding.Ascii);
            var array = MutableStringOps.Unpack(input, format);
            var red = Convert.ToInt32(array[0]);
            var green = Convert.ToInt32(array[1]);
            var blue = Convert.ToInt32(array[2]);
            var alpha = Convert.ToInt32(array[3]);

            return new Color(red, green, blue, alpha);
        }
    }
}