using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Windows;
using System.Windows.Threading;
using IronRuby.Builtins;
using IronRuby.Runtime;

namespace RMXPx
{
    // TODO: Clean this up.
    [RubyClass("Graphics")]
    public class Graphics
    {
        private const int DefaultFrameRate = 40;
#if SILVERLIGHT
        private static readonly Dispatcher _dispatcher = Application.Current.RootVisual.Dispatcher;
#else
        private static readonly Dispatcher _dispatcher;
#endif

        private static readonly Timer _timer;
        static Graphics()
        {
            _timer = new Timer(25);
        }

        public static void AddSprite(RubyContext context, Sprite sprite)
        {
            if (sprite.Viewport != null) throw new InvalidOperationException(
                "The sprite provided is contained within a Viewport.");

            GetRenderables(context).Add(sprite);
        }

        public static void AddViewport(RubyContext context, Viewport viewport)
        {
            GetRenderables(context).Add(viewport);
        }

        private static List<IRenderable> GetRenderables(RubyContext context)
        {
            var graphicsClass = context.GetClass(typeof(Graphics));
            return GetRenderables(graphicsClass);
        }

        private static List<IRenderable> GetRenderables(RubyClass self)
        {
            object renderables;
            if (!self.TryGetClassVariable("renderables", out renderables))
            {
                renderables = new List<IRenderable>();
                self.SetClassVariable("renderables", renderables);
            }

            return renderables as List<IRenderable>;
        }

        [RubyMethod("update", RubyMethodAttributes.PublicSingleton)]
        public static void Update(RubyClass self)
        {
#if SILVERLIGHT
            _timer.Wait();

            Sync.Action(() =>
            {

                var backBuffer = new Bitmap(640, 480, Font.GetDefaultCopy(self.Context));
                var renderables = GetRenderables(self);

                var sortedRenderable = renderables
                    .Where(r => !r.Disposed && r.Visible)
                    .OrderBy(r => r.Z)
                    .ToList();

                foreach (var renderable in sortedRenderable)
                {
                    if (renderable is Sprite)
                    {
                        var sprite = (Sprite)renderable;
                        backBuffer.Blt(sprite.X - sprite.OX, sprite.Y - sprite.OY, sprite.Bitmap, sprite.SrcRect,
                                    sprite.Opacity, sprite.BlendType);
                    }
                    else if (renderable is Viewport)
                    {
                        var viewport = renderable as Viewport;

                        var sprites = viewport.Sprites.Where(s => s.Visible).OrderBy(s => s.Z);
                        foreach (var sprite in sprites)
                        {
                            backBuffer.Blt(
                                viewport.Rect.X - viewport.OX + sprite.X - sprite.OX,
                                viewport.Rect.Y - viewport.OY + sprite.Y - sprite.OX,
                                sprite.Bitmap,
                                sprite.ActualSrcRect,
                                sprite.Opacity,
                                sprite.BlendType);
                        }

                        // TODO: draw the viewport's tone and flash
                        if (viewport.Color.Alpha != 0)
                        {
                            var colorBitmap = new Bitmap(viewport.Rect.Width, viewport.Rect.Height, Font.GetDefaultCopy(self.Context));
                            colorBitmap.FillRect(colorBitmap.GetRect(), viewport.Color);
                            backBuffer.Blt(viewport.Rect.X, viewport.Rect.Y, colorBitmap, colorBitmap.GetRect(), 255);
                        }
                    }
                }

                var surface = GetSurfaceBmp(self);
                surface.Blt(0, 0, backBuffer, new Rect(0, 0, 640, 480), null);
                surface.Invalidate();

                SetFrameCount(self, GetFrameCount(self) + 1);
            });
#endif
        }

        [RubyMethod("surface_bmp", RubyMethodAttributes.PublicSingleton)]
        public static void SetSurfaceBmp(RubyClass self, Bitmap bmp)
        {
            self.SetClassVariable("surface_bmp", bmp);
        }

        [RubyMethod("surface_bmp", RubyMethodAttributes.PublicSingleton)]
        public static Bitmap GetSurfaceBmp(RubyClass self)
        {
            object bmp;
            self.TryGetClassVariable("surface_bmp", out bmp);
            return bmp as Bitmap;
        }

        [RubyMethod("freeze", RubyMethodAttributes.PublicSingleton)]
        public static void Freeze(RubyClass self)
        {

        }

        [RubyMethod("transition", RubyMethodAttributes.PublicSingleton)]
        public static void Transition(RubyClass self)
        {

        }

        // TODO: Figure out WTF this means:
        // Resets the screen refresh timing. After a time-consuming process,
        // call this method to prevent extreme frame skips.
        [RubyMethod("frame_reset", RubyMethodAttributes.PublicSingleton)]
        public static void FrameReset(RubyClass self)
        {
        }

        [RubyMethod("frame_rate", RubyMethodAttributes.PublicSingleton)]
        public static int GetFrameRate(RubyClass self)
        {
            object frameRate;
            if (self.TryGetClassVariable("frame_rate", out frameRate))
            {
                return (int)frameRate;
            }

            return DefaultFrameRate;
        }

        [RubyMethod("frame_rate=", RubyMethodAttributes.PublicSingleton)]
        public static void SetFrameRate(RubyClass self, int frameRate)
        {
            self.SetClassVariable("frame_rate", frameRate);
        }

        [RubyMethod("frame_count", RubyMethodAttributes.PublicSingleton)]
        public static int GetFrameCount(RubyClass self)
        {
            object frameCount;
            if (self.TryGetClassVariable("frame_count", out frameCount))
            {
                return (int)frameCount;
            }

            return DefaultFrameRate;
        }

        [RubyMethod("frame_count=", RubyMethodAttributes.PublicSingleton)]
        public static void SetFrameCount(RubyClass self, int frameCount)
        {
            self.SetClassVariable("frame_count", frameCount);
        }
    }
}