using System.IO;
using System.Runtime.InteropServices;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using Microsoft.Scripting.Runtime;

namespace RMXPx
{
    public class Bitmap
    {
        private WriteableBitmap _writableBitmap;

        public Font Font { get; set; }
        public bool IsDisposed { get; private set; }
        public int Width { get; private set; }
        public int Height { get; private set; }

        private Bitmap(Font font)
        {
            Font = font;
        }

        public Bitmap(WriteableBitmap bitmap, Font/*!*/ font)
            : this(font)
        {
            _writableBitmap = bitmap;
            Sync.Action(() =>
                            {
                                Width = _writableBitmap.PixelWidth;
                                Height = _writableBitmap.PixelHeight;
                            });
        }

        public Bitmap(Stream stream, Font/*!*/ font)
            : this(font)
        {
#if SILVERLIGHT
            Sync.Action(() =>
                            {
                                _writableBitmap = new WriteableBitmap(0, 0);
                                _writableBitmap.SetSource(stream);
                                Width = _writableBitmap.PixelWidth;
                                Height = _writableBitmap.PixelHeight;
                            });
#endif
        }

        public Bitmap(int width, int height, Font/*!*/ font)
            : this(font)
        {
#if SILVERLIGHT
            Sync.Action(() =>
                            {
                                _writableBitmap = new WriteableBitmap(width, height);
                                Width = width;
                                Height = height;
                            });
#else
            // HACK: I'm completely bullshitting this
            var bmp = new WriteableBitmap(width, height, 0, 0, PixelFormats.Default, BitmapPalettes.Halftone8Transparent);
#endif

        }

        public void Dispose()
        {
            _writableBitmap = null;
            IsDisposed = true;
        }

        public Rect GetRect()
        {
            return new Rect(0, 0, Width, Height);
        }

        public Rect GetTextSize(string str)
        {
            // TODO: Impl
            return new Rect(0, 0, 0, 0);
        }

        public void Invalidate()
        {
#if SILVERLIGHT
            Sync.Action(() => _writableBitmap.Invalidate());
#endif
        }

        public void Blt([NotNull]int/*!*/ x, [NotNull]int/*!*/ y,
            [NotNull]Bitmap/*!*/ sourceBitmap, [NotNull]Rect/*!*/ sourceRect, [Optional]int? opacity)
        {
            Sync.Action(() =>
                            {
                                opacity = opacity == null || opacity > 255 ? 255 : opacity;
                                opacity = opacity < 0 ? 0 : opacity;

                                _writableBitmap.Blit(
                                    new Point(x, y),
                                    sourceBitmap._writableBitmap,
                                    new System.Windows.Rect(sourceRect.X, sourceRect.Y, sourceRect.Width, sourceRect.Height),
                                    System.Windows.Media.Color.FromArgb((byte)opacity, 255, 255, 255), WriteableBitmapExtensions.BlendMode.Alpha);
                            });

        }

        public void Blt([NotNull]int/*!*/ x, [NotNull]int/*!*/ y,
            [NotNull]Bitmap/*!*/ sourceBitmap, [NotNull]Rect/*!*/ sourceRect, [Optional]int? opacity, int blendType)
        {
            Sync.Action(() =>
                            {
                                opacity = opacity == null || opacity > 255 ? 255 : opacity;
                                opacity = opacity < 0 ? 0 : opacity;

                                WriteableBitmapExtensions.BlendMode mode = WriteableBitmapExtensions.BlendMode.Alpha;
                                switch (blendType)
                                {
                                    case (0):
                                        mode = WriteableBitmapExtensions.BlendMode.Alpha;
                                        break;
                                    case (1):
                                        mode = WriteableBitmapExtensions.BlendMode.Additive;
                                        break;
                                    case (2):
                                        mode = WriteableBitmapExtensions.BlendMode.Subtractive;
                                        break;
                                }

                                _writableBitmap.Blit(
                                    new Point(x, y),
                                    sourceBitmap._writableBitmap,
                                    new System.Windows.Rect(sourceRect.X, sourceRect.Y, sourceRect.Width, sourceRect.Height),
                                    System.Windows.Media.Color.FromArgb((byte)opacity, 255, 255, 255), mode);
                            });
        }

        public void StretchBlt([NotNull]Rect/*!*/ destRect, [NotNull]Bitmap/*!*/ sourceBitmap,
            [NotNull]Rect/*!*/ sourceRect, [Optional]int? opacity)
        {
            opacity = opacity == null || opacity > 255 ? 255 : opacity;
            opacity = opacity < 0 ? 0 : opacity;

            // TODO: impl
        }

        public void FillRect(int x, int y, int width, int height, Color color)
        {
            Sync.Action(() =>
                            {
                                var c = System.Windows.Media.Color.FromArgb((byte)color.Alpha, (byte)color.Red, (byte)color.Green,
                                                        (byte)color.Blue);

                                _writableBitmap.FillRectangle(x, y, x + width, y + height, c);
                            });
        }

        public void FillRect(Rect rect, Color color)
        {
            FillRect(rect.X, rect.Y, rect.Width, rect.Height, color);
        }

        public void Clear()
        {
            Sync.Action(() => _writableBitmap.Clear(Colors.Transparent));
        }

        public Color GetPixel(int x, int y)
        {
            Color color = null;
            Sync.Action(() =>
                            {
                                var c = _writableBitmap.GetPixel(x, y);
                                color = new Color(c.R, c.G, c.B, c.A);
                            });

            return color;
        }

        public void SetPixel(int x, int y, Color color)
        {
            Sync.Action(() =>
                            {
                                var c = System.Windows.Media.Color.FromArgb(
                                    (byte)color.Alpha, (byte)color.Red, (byte)color.Green, (byte)color.Blue);

                                _writableBitmap.SetPixel(x, y, c);
                            });
        }

        public void HueChange(int hue)
        {
            //var hueShift = hue % 360;
            // TODO: impl
        }

        public void DrawText(int x, int y, int width, int height, string str, int align)
        {
            // TODO: impl
        }

        public void DrawText(Rect rect, string str, int align)
        {
            // TODO: impl
        }

        public void SetTextSize(string str)
        {
            // TODO: impl
        }
    }
}