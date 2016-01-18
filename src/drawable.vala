using Cairo;

public abstract class Drawable : Object {
    public abstract void draw(Context ctx, Vector2D translation, double zoom);
    public abstract Vector2D c { get; set; } // center point
    public abstract Vector2D s { get; } // size
    public abstract string id { owned get; }
}
