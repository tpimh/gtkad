using Cairo;

public static double translate_x = 10.0;
public static double translate_y = 10.0;
public static double zoom = 1.0;

public static double tx(double x) {
    return translate_x + x * zoom;
}

public static double ty(double y) {
    return translate_y + y * zoom;
}

public abstract class Drawable : Object {
    public abstract void draw(Context ctx);
}
