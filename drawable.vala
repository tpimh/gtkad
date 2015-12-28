using Cairo;

public static double translate_x = 10.0;
public static double translate_y = 10.0;
public static double zoom = 1.0;

public abstract class Drawable : Object {
    public abstract void draw(Context ctx);
    public abstract double x { get; set; }
    public abstract double y { get; set; }
}
