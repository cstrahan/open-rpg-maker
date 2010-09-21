using System;
using System.Runtime.InteropServices;
using IronRuby.Builtins;
using IronRuby.Runtime;

namespace RMXPx
{
    [RubyClass]
    public class Tone
    {
        private int _red;
        public int Red
        {
            get { return _red; }
            set
            {
                _red = value;
                if (_red < -255) _red = 0;
                if (_red > 255) _red = 255;
            }
        }

        private int _green;
        public int Green
        {
            get { return _green; }
            set
            {
                _green = value;
                if (_red < -255) _green = 0;
                else if (_red > 255) _green = 255;
            }
        }

        private int _blue;
        public int Blue
        {
            get { return _blue; }
            set
            {
                _blue = value;
                if (_blue < -255) _blue = 0;
                else if (_blue > 255) _blue = 255;
            }
        }

        private int _gray;
        public int Gray
        {
            get { return _gray; }
            set
            {
                _gray = value;
                if (_gray < -255) _gray = 0;
                else if (_gray > 255) _gray = 255;
            }
        }

        public Tone()
        {
        }

        public Tone(int red, int green, int blue)
            : this(red, green, blue, 0)
        {
        }

        public Tone(int red, int green, int blue, int gray)
        {
            Red = red;
            Green = green;
            Blue = blue;
            Gray = gray;
        }

        [RubyMethod("red")]
        public static int GetRed(Tone self)
        {
            return self.Red;
        }
        [RubyMethod("red=")]
        public static void SetRed(Tone self, int red)
        {
            self.Red = red;
        }
        [RubyMethod("green")]
        public static int GetGreen(Tone self)
        {
            return self.Green;
        }
        [RubyMethod("green=")]
        public static void SetGreen(Tone self, int green)
        {
            self.Green = green;
        }
        [RubyMethod("blue")]
        public static int GetBlue(Tone self)
        {
            return self.Blue;
        }
        [RubyMethod("blue=")]
        public static void SetBlue(Tone self, int blue)
        {
            self.Blue = blue;
        }

        [RubyConstructor]
        public static Tone Create(RubyClass self, int red, int green, int blue, [Optional]int? gray)
        {
            return new Tone(red, green, blue, gray ?? 0);
        }

        [RubyMethod("_dump")]
        public static MutableString Dump(
            ConversionStorage<IntegerValue>/*!*/ integerConversion,
            ConversionStorage<double>/*!*/ floatConversion,
            ConversionStorage<MutableString>/*!*/ stringCast,
            ConversionStorage<MutableString>/*!*/ tosConversion,
            Tone self,
            [Optional]int? aDepth)
        {
            var array = new RubyArray(new[] { self.Red, self.Green, self.Blue, self.Gray });
            return ArrayOps.Pack(integerConversion, floatConversion, stringCast, tosConversion, array, MutableString.Create("d4", RubyEncoding.Ascii));
        }


        [RubyMethod("_load", RubyMethodAttributes.PublicSingleton)]
        public static Tone Load(RubyClass self, MutableString input)
        {
            var format = MutableString.Create("d4", RubyEncoding.Ascii);
            var array = MutableStringOps.Unpack(input, format);
            var red = Convert.ToInt32(array[0]);
            var green = Convert.ToInt32(array[1]);
            var blue = Convert.ToInt32(array[2]);
            var gray = Convert.ToInt32(array[3]);

            return new Tone(red, green, blue, gray);
        }

        [RubyMethod("set")]
        public static void Set(Tone self, int red, int green, int blue, [Optional]int? gray)
        {
            self.Red = red;
            self.Green = green;
            self.Blue = blue;
            self.Gray = gray ?? 0;
        }
    }
}


/*
 
  def initialize(red, green, blue, gray=0)
    set red, green, blue, gray
  end
  
  # Sets all components at once.
  def set(red, green, blue, gray=0)
    self.red   = red
    self.green = green
    self.blue  = blue
    self.gray  = gray
  end
  
  def _dump(d = 0)
    [@red, @green, @blue, @gray].pack('d4')
  end
  
  def self._load(s)
    Tone.new(*s.unpack('d4'))
  end
*/