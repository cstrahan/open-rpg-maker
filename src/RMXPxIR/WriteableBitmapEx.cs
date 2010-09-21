using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace System.Windows.Media.Imaging
{
    // This is a shim to get this project to shut the fuck up and compile.
    public static class WriteableBitmapExtensions
    {
        public enum BlendMode
        {
            Alpha,
            Additive,
            Subtractive,
            Mask,
            Multiply,
            None
        }

        public static void Blit(this WriteableBitmap bmp, Rect destRect, WriteableBitmap source, Rect sourceRect, BlendMode BlendMode)
        {
        }

        public static void Blit(this WriteableBitmap bmp, Rect destRect, WriteableBitmap source, Rect sourceRect)
        {
        }

        public static void Blit(this WriteableBitmap bmp, Point destPosition, WriteableBitmap source, Rect sourceRect, Color color, BlendMode BlendMode)
        {
        }

        public static void Blit(this WriteableBitmap bmp, Rect destRect, WriteableBitmap source, Rect sourceRect, Color color, BlendMode BlendMode)
        {
        }


        private const float PreMultiplyFactor = 1 / 255f;
        private const int SizeOfARGB = 4;

        public static void Clear(this WriteableBitmap bmp, Color color)
        {
        }

        public static void Clear(this WriteableBitmap bmp)
        {
        }

        public static WriteableBitmap Clone(this WriteableBitmap bmp)
        {
            return null;
        }

        public static void ForEach(this WriteableBitmap bmp, System.Func<int, int, Color> func)
        {
        }

        public static void ForEach(this WriteableBitmap bmp, System.Func<int, int, Color, Color> func)
        {
        }

        public static int GetPixeli(this WriteableBitmap bmp, int x, int y)
        {
            return 0;
        }

        public static Color GetPixel(this WriteableBitmap bmp, int x, int y)
        {
            return Colors.Transparent;
        }

        public static void SetPixeli(this WriteableBitmap bmp, int index, byte r, byte g, byte b)
        {
        }

        public static void SetPixel(this WriteableBitmap bmp, int x, int y, byte r, byte g, byte b)
        {
        }

        public static void SetPixeli(this WriteableBitmap bmp, int index, byte a, byte r, byte g, byte b)
        {
        }

        public static void SetPixel(this WriteableBitmap bmp, int x, int y, byte a, byte r, byte g, byte b)
        {
        }

        public static void SetPixeli(this WriteableBitmap bmp, int index, Color color)
        {
        }

        public static void SetPixel(this WriteableBitmap bmp, int x, int y, Color color)
        {
        }

        public static void SetPixeli(this WriteableBitmap bmp, int index, byte a, Color color)
        {
        }

        public static void SetPixel(this WriteableBitmap bmp, int x, int y, byte a, Color color)
        {
        }

        public static void SetPixeli(this WriteableBitmap bmp, int index, int color)
        {
        }

        public static void SetPixel(this WriteableBitmap bmp, int x, int y, int color)
        {
        }

      public static void DrawLineBresenham(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, Color color)
      {
      }

      public static void DrawLineBresenham(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int color)
      {
      }

      public static void DrawLineDDA(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, Color color)
      {
      }

      public static void DrawLineDDA(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int color)
      {
      }

      public static void DrawLine(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, Color color)
      {
      }

      public static void DrawLine(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int color)
      {
      }

        public static void DrawLine(int[] pixels, int pixelWidth, int pixelHeight, int x1, int y1, int x2, int y2, int color)
      {
      }

      public static void DrawPolyline(this WriteableBitmap bmp, int[] points, Color color)
      {
      }

      public static void DrawPolyline(this WriteableBitmap bmp, int[] points, int color)
      {            
      }

      public static void DrawTriangle(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int x3, int y3, Color color)
      {
      }

      public static void DrawTriangle(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int x3, int y3, int color)
      {
      }

      public static void DrawQuad(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4, Color color)
      {
      }

      public static void DrawQuad(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4, int color)
      {
      }

      public static void DrawRectangle(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, Color color)
      {
      }

      public static void DrawRectangle(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int color)
      {
      }

      public static void DrawEllipse(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, Color color)
      {
      }

      public static void DrawEllipse(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int color)
      {
      }

      public static void DrawEllipseCentered(this WriteableBitmap bmp, int xc, int yc, int xr, int yr, Color color)
      {
      }

      public static void DrawEllipseCentered(this WriteableBitmap bmp, int xc, int yc, int xr, int yr, int color)
      {
      }

           public static void FillRectangle(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, Color color)
      {
      }

      public static void FillRectangle(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int color)
      {
      }

      public static void FillEllipse(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, Color color)
      {
      }

      public static void FillEllipse(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int color)
      {
      }

      public static void FillEllipseCentered(this WriteableBitmap bmp, int xc, int yc, int xr, int yr, Color color)
      {
      }

      public static void FillEllipseCentered(this WriteableBitmap bmp, int xc, int yc, int xr, int yr, int color)
      {
      }

      public static void FillPolygon(this WriteableBitmap bmp, int[] points, Color color)
      {
      }

      public static void FillPolygon(this WriteableBitmap bmp, int[] points, int color)
      {
      }

      public static void FillQuad(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4, Color color)
      {
      }

      public static void FillQuad(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4, int color)
      {
      }

      public static void FillTriangle(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int x3, int y3, Color color)
      {
      }

      public static void FillTriangle(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int x3, int y3, int color)
      {
      }

      public static void FillBeziers(this WriteableBitmap bmp, int[] points, Color color)
      {
      }

      public static void FillBeziers(this WriteableBitmap bmp, int[] points, int color)
      {
      }

      public static void FillCurve(this WriteableBitmap bmp, int[] points, float tension, Color color)
      {
      }

      public static void FillCurve(this WriteableBitmap bmp, int[] points, float tension, int color)
      {
      }

      public static void FillCurveClosed(this WriteableBitmap bmp, int[] points, float tension, Color color)
      {
      }

      public static void FillCurveClosed(this WriteableBitmap bmp, int[] points, float tension, int color)
      {
      }
    }
}