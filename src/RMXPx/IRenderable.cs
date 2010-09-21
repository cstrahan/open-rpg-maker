namespace RMXPx
{
    public interface IRenderable
    {
        int Z { get; set; }
        bool Disposed { get; }
        bool Visible { get; }
    }
}