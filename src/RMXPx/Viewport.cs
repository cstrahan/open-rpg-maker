using System.Collections.Generic;
using IronRuby.Builtins;
using IronRuby.Runtime;

namespace RMXPx
{
    [RubyClass]
    public class Viewport : IRenderable
    {
        public Rect/*!*/ Rect { get; set; }
        public bool Visible { get; set; }
        public int Z { get; set; }
        public int OX { get; set; }
        public int OY { get; set; }
        public Color Color { get; set; }
        public Tone Tone { get; set; }
        public bool Disposed { get; private set; }
        private IList<Sprite> _sprites;
        public IEnumerable<Sprite> Sprites
        {
            get { return _sprites; }
        }

        public Viewport(Rect rect)
            : this(rect.X, rect.Y, rect.Width, rect.Height)
        {
        }

        public void AddSprite(Sprite sprite)
        {
            _sprites.Add(sprite);
        }

        public Viewport(int x, int y, int width, int height)
        {
            Visible = true;
            OX = OY = Z = 0;
            Color = new Color(0, 0, 0, 0);
            Tone = new Tone(0, 0, 0, 0);
            Disposed = false;
            Rect = new Rect(x, y, width, height);
            _sprites = new List<Sprite>();
        }

        public void Dispose()
        {
            // TODO: call dispose on all sprites?
            _sprites.Clear();
            Disposed = true;
        }

        public void Flash()
        {
        }

        public void Update()
        {
        }

        [RubyMethod("rect")]
        public static Rect GetRect(Viewport self)
        {
            return self.Rect;
        }

        [RubyMethod("rect=")]
        public static void SetRect(Viewport self, Rect rect)
        {
            self.Rect = rect;
        }

        [RubyMethod("visible")]
        public static bool GetVisible(Viewport self)
        {
            return self.Visible;
        }

        [RubyMethod("visible=")]
        public static void SetVisible(Viewport self, bool visible)
        {
            self.Visible = visible;
        }

        [RubyMethod("z")]
        public static int GetZ(Viewport self)
        {
            return self.Z;
        }

        [RubyMethod("z=")]
        public static void SetZ(Viewport self, int z)
        {
            self.Z = z;
        }

        [RubyMethod("ox")]
        public static int GetOX(Viewport self)
        {
            return self.OX;
        }

        [RubyMethod("ox=")]
        public static void SetOX(Viewport self, int ox)
        {
            self.OX = ox;
        }

        [RubyMethod("oy")]
        public static int GetOY(Viewport self)
        {
            return self.OY;
        }

        [RubyMethod("oy=")]
        public static void SetOY(Viewport self, int oy)
        {
            self.OY = oy;
        }

        [RubyMethod("color")]
        public static Color GetColor(Viewport self)
        {
            return self.Color;
        }

        [RubyMethod("color=")]
        public static void SetColor(Viewport self, Color color)
        {
            self.Color = color;
        }

        [RubyMethod("tone")]
        public static Tone GetTone(Viewport self)
        {
            return self.Tone;
        }

        [RubyMethod("tone=")]
        public static void SetTone(Viewport self, Tone tone)
        {
            self.Tone = tone;
        }

        [RubyMethod("disposed?")]
        public static bool GetDisposed(Viewport self)
        {
            return self.Disposed;
        }

        [RubyMethod("dispose")]
        public static void Dispose(Viewport self)
        {
            self.Dispose();
        }

        [RubyMethod("flash")]
        public static void Flash(Viewport self, Color color, int duration)
        {
        }

        [RubyMethod("update")]
        public static void Update(Viewport self)
        {
        }

        [RubyConstructor]
        public static Viewport Create(RubyClass self, int x, int y, int width, int height)
        {
            var viewport = new Viewport(x, y, width, height);
            Graphics.AddViewport(self.Context, viewport);
            return viewport;
        }

        [RubyConstructor]
        public static Viewport Create(RubyClass self, Rect rect)
        {
            return Create(self, rect.X, rect.Y, rect.Width, rect.Height);
        }
    }
}