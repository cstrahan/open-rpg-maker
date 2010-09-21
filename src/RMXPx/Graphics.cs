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
            _timer.Wait();

            var surface = GetSurfaceBmp(self);
            var renderables = GetRenderables(self);

            var sortedRenderable = renderables
                .Where(r => !r.Disposed && r.Visible)
                .OrderBy(r => r.Z)
                .ToList();

            foreach (var renderable in sortedRenderable)
            {
                var sprite = renderable as Sprite;
                if (sprite != null && sprite.Visible)
                {
                    surface.Blt(sprite.X - sprite.OX, sprite.Y - sprite.OY, sprite.Bitmap, sprite.SrcRect,
                                sprite.Opacity, sprite.BlendType);
                }
                else
                {
                    var viewport = renderable as Viewport;
                    foreach (var sprite1 in viewport.Sprites)
                    {
                        surface.Blt(
                            viewport.Rect.X - viewport.OX + sprite1.X - sprite1.OX, 
                            viewport.Rect.Y - viewport.OY + sprite1.Y - sprite1.OX, 
                            sprite1.Bitmap, 
                            sprite1.ActualSrcRect,
                            sprite1.Opacity, 
                            sprite1.BlendType);
                    }
                    // TODO: draw the viewport's color, tone and flash
                }
            }

#if SILVERLIGHT
            _dispatcher.BeginInvoke(() => surface.Invalidate());
#endif
            //surface.Invalidate();
            SetFrameCount(self, GetFrameCount(self) + 1);
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