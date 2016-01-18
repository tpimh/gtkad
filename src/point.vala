using Cairo;

public class Point : Drawable {
    public override Vector2D c { get; set; }

    public Point(double x, double y) {
        c = { x, y };
    }

    public double x {
        get {
            return c.x;
        }
    }

    public double y {
        get {
            return c.y;
        }
    }

    public override void draw(Context ctx, Vector2D translation, double zoom) {
        ctx.set_source_rgb(1.0, 0, 0);
        ctx.arc(c.x * zoom, c.y * zoom, 0.8, 0, 2.0 * 3.14);
        ctx.fill();
    }

    public override string id {
        owned get {
            return @"P($c)";
        }
    }
}
