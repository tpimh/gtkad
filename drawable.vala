using Cairo;

public static double translate_x = 10.0;
public static double translate_y = 10.0;
public static double zoom = 1.0;

public abstract class Drawable : Object {
    public abstract void draw(Context ctx);
    public abstract Vector2D c { get; set; } // center point
    public abstract string id { owned get; }
}
