using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using Microsoft.Scripting.Runtime;
using System.Linq;

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
#if SILVERLIGHT
            Sync.Action(() =>
                            {
                                opacity = opacity == null || opacity > 255 ? 255 : opacity;
                                opacity = opacity < 0 ? 0 : opacity;

                                double scaleX = destRect.Width/(double) sourceRect.Width;
                                double scaleY = destRect.Height/(double) sourceRect.Height;

                                var sourceImage = new Image();
                                sourceImage.Source = sourceBitmap._writableBitmap;
                                sourceImage.Width = sourceBitmap.Width;
                                sourceImage.Height = sourceBitmap.Height;
                                sourceImage.Measure(new Size(sourceBitmap.Width, sourceBitmap.Height));

                                var viewBox = new Viewbox();
                                viewBox.Child = sourceImage;
                                viewBox.Stretch = Stretch.Fill;
                                viewBox.Width = sourceBitmap.Width*scaleX;
                                viewBox.Height = sourceBitmap.Height*scaleY;
                                viewBox.UpdateLayout();
                                viewBox.Measure(new Size(viewBox.Width, viewBox.Height));
                                viewBox.Arrange(new Rect(0, 0, (int) viewBox.Width, (int) viewBox.Height));

                                var scaledBitmap = new WriteableBitmap(viewBox, null);
                                scaledBitmap.Invalidate();

                                _writableBitmap.Blit(
                                    destRect,
                                    scaledBitmap,
                                    new System.Windows.Rect(sourceRect.X*scaleX, sourceRect.Y*scaleY,
                                                            sourceRect.Width*scaleX, sourceRect.Height*scaleY));
                            });
#endif
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

        // TODO: Remove this shitty shitty shitty method...
        public WriteableBitmap GetBmp()
        {
            return _writableBitmap;
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
            if (align != 0 && align != 1 && align != 2)
            {
                throw new ArgumentOutOfRangeException("align", "Expected an alignment of 0, 1 or 2");
            }
#if SILVERLIGHT
            Sync.Action(() =>
                            {
                                TextBlock textBlock = new TextBlock();
                                textBlock.Foreground = 
                                    new SolidColorBrush(
                                        System.Windows.Media.Color.FromArgb(
                                            (byte)Font.Color.Alpha,
                                            (byte)Font.Color.Red,
                                            (byte)Font.Color.Green,
                                            (byte)Font.Color.Blue));
                                textBlock.Text = str;
                                textBlock.FontFamily = new FontFamily(Font.Name);
                                textBlock.FontSize = Font.Size;
                                if (Font.Italic) textBlock.FontStyle = FontStyles.Italic;
                                if (Font.Bold) textBlock.FontWeight = FontWeights.Bold;

                                // Get the percentage we will need to shrink the text by
                                // (needs to be done regardless of alignment)
                                double scaleX = 1;
                                var actualWidth = textBlock.ActualWidth;
                                if (actualWidth > width)
                                {
                                    var diff = actualWidth - width;
                                    var percentage = diff/actualWidth;
                                    if (percentage >= 0.60) percentage = 0.60;
                                    scaleX = 1.00 - percentage;
                                }

                                // Figure out how far from the left we need to draw
                                double translateX;
                                switch (align)
                                {
                                    case 1:
                                        if (actualWidth >= width)
                                        {
                                            translateX = 0;
                                        }
                                        else
                                        {
                                            var midpoint = width/2;
                                            translateX = midpoint - ((actualWidth)/2);
                                        }
                                        break;
                                    case 2:
                                        if (actualWidth >= width)
                                        {
                                            translateX = 0;
                                        }
                                        else
                                        {
                                            translateX = width - actualWidth;
                                        }
                                        break;
                                    case 0:
                                    default:
                                        translateX = 0;
                                        break;
                                }

                                // Figure out the vertical location of the text
                                var actualHeight = textBlock.ActualHeight;
                                double translateY;
                                if (actualHeight >= height)
                                {
                                    translateY = 0;
                                }
                                else
                                {
                                    var midpoint = height/2;
                                    translateY = (midpoint - (actualHeight/2));
                                }

                                var transform = new CompositeTransform();
                                transform.ScaleX = scaleX;
                                transform.TranslateX = translateX;
                                transform.TranslateY = translateY;

                                WriteableBitmap bitmap = new WriteableBitmap((int) width, (int) height);
                                bitmap.Render(textBlock, transform);
                                // Need this following line, otherwise the next blit won't blit anything
                                bitmap.Invalidate();

                                _writableBitmap.Blit(
                                    new System.Windows.Rect(x, y, width, height),
                                    bitmap,
                                    new System.Windows.Rect(0, 0, width, height),
                                    WriteableBitmapExtensions.BlendMode.Alpha);
                            });
#endif
        }

        public void DrawText(Rect rect, string str, int align)
        {
            DrawText(rect.X, rect.Y, rect.Width, rect.Height, str, align);
        }

        public void SetTextSize(string str)
        {
            // TODO: impl
        }
    }
}