using System.Runtime.InteropServices;
using IronRuby.Builtins;
using IronRuby.Runtime;
using Microsoft.Scripting.Runtime;

namespace RMXPx
{
    [RubyClass("Sprite", Extends = typeof(Sprite))]
    public class SpriteOps
    {
        [RubyMethod("bitmap=")]
        public static void SetBitmap(Sprite self, Bitmap bitmap)
        {
            self.Bitmap = bitmap;
        }

        [RubyMethod("bitmap")]
        public static Bitmap GetBitmap(Sprite self)
        {
            return self.Bitmap;
        }

        [RubyMethod("src_rect=")]
        public static void SetSrcRect(Sprite self, Rect rect)
        {
            self.SrcRect = rect;
        }

        [RubyMethod("src_rect")]
        public static Rect GetSrcRect(Sprite self)
        {
            return self.SrcRect;
        }

        [RubyMethod("visible=")]
        public static void SetVisible(Sprite self, bool visible)
        {
            self.Visible = visible;
        }

        [RubyMethod("visible")]
        public static bool GetVisible(Sprite self)
        {
            return self.Visible;
        }

        [RubyMethod("x=")]
        public static void SetX(Sprite self, int x)
        {
            self.X = x;
        }

        [RubyMethod("x")]
        public static int GetX(Sprite self)
        {
            return self.X;
        }

        [RubyMethod("y=")]
        public static void SetY(Sprite self, int y)
        {
            self.Y = y;
        }

        [RubyMethod("y")]
        public static int GetY(Sprite self)
        {
            return self.Y;
        }
        [RubyMethod("z=")]
        public static void SetZ(Sprite self, int z)
        {
            self.Z = z;
        }

        [RubyMethod("z")]
        public static int GetZ(Sprite self)
        {
            return self.Z;
        }

        [RubyMethod("ox=")]
        public static void SetOX(Sprite self, int ox)
        {
            self.OY = ox;
        }

        [RubyMethod("ox")]
        public static int GetOX(Sprite self)
        {
            return self.OX;
        }

        [RubyMethod("oy=")]
        public static void SetOY(Sprite self, int oy)
        {
            self.OY = oy;
        }

        [RubyMethod("oy")]
        public static int GetOY(Sprite self)
        {
            return self.OY;
        }

        [RubyMethod("zoom_x=")]
        public static void SetZoomX(Sprite self, int zoomX)
        {
            self.ZoomX = zoomX;
        }

        [RubyMethod("zoom_x")]
        public static int GetZoomX(Sprite self)
        {
            return self.ZoomX;
        }

        [RubyMethod("zoom_y=")]
        public static void SetZoomY(Sprite self, int zoomY)
        {
            self.ZoomY = zoomY;
        }

        [RubyMethod("zoom_y")]
        public static int GetZoomY(Sprite self)
        {
            return self.ZoomY;
        }

        [RubyMethod("angle=")]
        public static void SetAngle(Sprite self, int angle)
        {
            self.Angle = angle;
        }

        [RubyMethod("angle")]
        public static int GetAngle(Sprite self)
        {
            return self.Angle;
        }

        [RubyMethod("mirror=")]
        public static void SetMirror(Sprite self, bool mirror)
        {
            self.Mirror = mirror;
        }

        [RubyMethod("mirror")]
        public static bool GetMirror(Sprite self)
        {
            return self.Mirror;
        }

        [RubyMethod("bush_depth=")]
        public static void SetBushDepth(Sprite self, int bushDepth)
        {
            self.BushDepth = bushDepth;
        }

        [RubyMethod("bush_depth")]
        public static int GetBushDepth(Sprite self)
        {
            return self.BushDepth;
        }

        [RubyMethod("opacity=")]
        public static void SetOpacity(Sprite self, int opacity)
        {
            self.Opacity = opacity;
        }

        [RubyMethod("opacity")]
        public static int GetOpacity(Sprite self)
        {
            return self.Opacity;
        }

        [RubyMethod("blend_type=")]
        public static void SetBlendType(Sprite self, int blendType)
        {
            self.BlendType = blendType;
        }

        [RubyMethod("blend_type")]
        public static int GetBlendType(Sprite self)
        {
            return self.BlendType;
        }

        [RubyMethod("color=")]
        public static void SetColor(Sprite self, Color color)
        {
            self.Color = color;
        }

        [RubyMethod("color")]
        public static Color GetColor(Sprite self)
        {
            return self.Color;
        }

        [RubyMethod("tone=")]
        public static void SetTone(Sprite self, Tone tone)
        {
            self.Tone = tone;
        }

        [RubyMethod("tone")]
        public static Tone GetTone(Sprite self)
        {
            return self.Tone;
        }

        [RubyMethod("viewport")]
        public static Viewport GetViewport(Sprite self)
        {
            return self.Viewport;
        }

        [RubyMethod("disposed?")]
        public static bool GetDisposed(Sprite self)
        {
            return self.Disposed;
        }

        [RubyMethod("dispose")]
        public static void Dispose(Sprite self)
        {
            self.Dispose();
        }

        [RubyMethod("flash")]
        public static void Flash(Sprite self, Color color, [DefaultProtocol] int duration)
        {
            // TODO: do this
        }

        [RubyMethod("update")]
        public static void Update(Sprite self)
        {
            // TODO: do this
        }

        [RubyConstructor]
        public static Sprite Create(RubyClass self, [Optional]Viewport viewport)
        {
            var sprite = new Sprite(viewport);
            if (viewport == null)
            {
                Graphics.AddSprite(self.Context, sprite);
            }

            return sprite;
        }
    }
}