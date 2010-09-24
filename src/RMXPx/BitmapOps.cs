using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using IronRuby.Builtins;
using IronRuby.Runtime;
using Microsoft.Scripting.Runtime;

namespace RMXPx
{
    [RubyClass("Bitmap", Extends = typeof(Bitmap))]
    public class BitmapOps
    {
        [RubyConstructor]
        public static Bitmap Create(RubyClass/*!*/ self, [DefaultProtocol, NotNull]string/*!*/ path)
        {
            var dir = Path.GetDirectoryName(path);
            var pattern = Path.GetFileName(path);
            var possibleFiles = self.Context.DomainManager.Platform.GetFileSystemEntries(dir, pattern, true, false);
            var imagePath = possibleFiles.First(); // Use the first match
            var stream = self.Context.DomainManager.Platform.OpenInputFileStream(imagePath);
            return new Bitmap(stream, Font.GetDefaultCopy(self.Context));
        }

        [RubyConstructor]
        public static Bitmap Create(RubyClass/*!*/ self, [DefaultProtocol, NotNull]int/*!*/ width, [DefaultProtocol, NotNull]int/*!*/ height)
        {
            return new Bitmap(width, height, Font.GetDefaultCopy(self.Context));
        }

        [RubyMethod("dispose", RubyMethodAttributes.PublicInstance)]
        public static void Dispose(Bitmap/*!*/ self)
        {
            self.Dispose();
        }

        [RubyMethod("disposed?", RubyMethodAttributes.PublicInstance)]
        public static bool GetDisposed(Bitmap/*!*/ self)
        {
            return self.IsDisposed;
        }

        [RubyMethod("width", RubyMethodAttributes.PublicInstance)]
        public static int GetWidth(Bitmap/*!*/ self)
        {
            return self.Width;
        }

        [RubyMethod("height", RubyMethodAttributes.PublicInstance)]
        public static int GetHeight(Bitmap/*!*/ self)
        {
            return self.Height;
        }

        [RubyMethod("rect", RubyMethodAttributes.PublicInstance)]
        public static Rect GetRect(Bitmap/*!*/ self)
        {
            return self.GetRect();
        }

        [RubyMethod("blt", RubyMethodAttributes.PublicInstance)]
        public static void Blt(Bitmap/*!*/ self, [NotNull]int/*!*/ x, [NotNull]int/*!*/ y,
                               [NotNull]Bitmap/*!*/ sourceBitmap, [NotNull]Rect/*!*/ sourceRect, [Optional]int? opacity)
        {
            self.Blt(x, y, sourceBitmap, sourceRect, opacity);
        }

        [RubyMethod("stretch_blt", RubyMethodAttributes.PublicInstance)]
        public static void StretchBlt(Bitmap/*!*/ self, [NotNull]Rect/*!*/ destRect, [NotNull]Bitmap/*!*/ sourceBitmap,
                                      [NotNull]Rect/*!*/ sourceRect, [Optional]int? opacity)
        {
            self.StretchBlt(destRect, sourceBitmap, sourceRect, opacity);
        }

        [RubyMethod("fill_rect", RubyMethodAttributes.PublicInstance)]
        public static void FillRect(Bitmap/*!*/ self, int x, int y, int width, int height, Color color)
        {
            self.FillRect(x, y, width, height, color);
        }

        [RubyMethod("fill_rect", RubyMethodAttributes.PublicInstance)]
        public static void FillRect(Bitmap/*!*/ self, Rect rect, Color color)
        {
            FillRect(self, rect.X, rect.Y, rect.Width, rect.Height, color);
        }

        [RubyMethod("clear", RubyMethodAttributes.PublicInstance)]
        public static void Clear(Bitmap/*!*/ self)
        {
            self.Clear();
        }

        [RubyMethod("get_pixel", RubyMethodAttributes.PublicInstance)]
        public static Color GetPixel(Bitmap/*!*/ self, int x, int y)
        {
            return self.GetPixel(x, y);
        }

        [RubyMethod("set_pixel", RubyMethodAttributes.PublicInstance)]
        public static void SetPixel(Bitmap/*!*/ self, int x, int y, Color color)
        {
            self.SetPixel(x, y, color);
        }

        [RubyMethod("hue_change", RubyMethodAttributes.PublicInstance)]
        public static void HueChange(Bitmap/*!*/ self, int hue)
        {
            self.HueChange(hue);
        }

        [RubyMethod("draw_text", RubyMethodAttributes.PublicInstance)]
        public static void DrawText(Bitmap/*!*/ self, int x, int y, int width, int height, string str, [Optional] int? align)
        {
            self.DrawText(x, y, width, height, str, align ?? 0);
        }

        [RubyMethod("draw_text", RubyMethodAttributes.PublicInstance)]
        public static void DrawText(Bitmap/*!*/ self, Rect rect, string str, [Optional]int? align)
        {
            self.DrawText(rect, str, align ?? 0);
        }

        [RubyMethod("text_size", RubyMethodAttributes.PublicInstance)]
        public static Rect GetTextSize(Bitmap/*!*/ self, string str)
        {
            return self.GetTextSize(str);
        }

        [RubyMethod("invalidate", RubyMethodAttributes.PublicInstance)]
        public static void Invalidate(Bitmap/*!*/ self)
        {
            self.Invalidate();
        }
    }
}