using System.Collections.Generic;

namespace RMXPx
{
    // TODO: throw when assigning blend_type less than 0 or greater than 2
    public class Sprite : IRenderable
    {
        private Bitmap _bitmap;
        public Bitmap Bitmap
        {
            get { return _bitmap; }
            set
            {
                _bitmap = value;
                SrcRect = _bitmap.GetRect();
            }
        }

        public Rect ActualSrcRect
        {
            get
            {
                if (Viewport == null)
                {
                    return SrcRect;
                }

                return new Rect(SrcRect.X + Viewport.OX + OX - X,
                                SrcRect.Y + Viewport.OY + OY - Y,
                                Viewport.Rect.Width,
                                Viewport.Rect.Height)
                                .Intersect(SrcRect);
            }
        }

        public bool Visible { get; set; }
        public Rect/*!*/ SrcRect { get; set; }
        public int X { get; set; }
        public int Y { get; set; }
        public int Z { get; set; }
        public int OX { get; set; }
        public int OY { get; set; }
        public int ZoomX { get; set; }
        public int ZoomY { get; set; }
        public int Angle { get; set; }
        public bool Mirror { get; set; }
        public int BushDepth { get; set; }
        public int Opacity { get; set; }
        public int BlendType { get; set; }
        public Color/*!*/ Color { get; set; }
        public Tone/*!*/ Tone { get; set; }
        private readonly Viewport _viewport;
        public Viewport Viewport
        {
            get { return _viewport; }
        }

        

        public bool Disposed { get; private set; }

        //public Sprite() : this(null)
        //{
        //}

        public Sprite(Viewport viewport) 
        {
            _viewport = viewport;
            if (_viewport != null)
            {
                _viewport.AddSprite(this);
                if (_viewport.Z == 102)
                {
                    
                }
            }

            SrcRect = new Rect(0, 0, 0, 0);
            Visible = true;
            X = 0;
            Y = 0;
            Z = 0;
            OX = 0;
            OY = 0;
            ZoomX = 0;
            ZoomY = 0;
            Angle = 0;
            Mirror = false;
            BushDepth = 0;
            Opacity = 255;
            BlendType = 0;
            Color = new Color(0, 0, 0, 0);
            Tone = new Tone(0, 0, 0, 0);
        }

        public void Dispose()
        {

        }   
    }
}