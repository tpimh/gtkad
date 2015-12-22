using Cairo;

public class Point : Drawable {
    public double x { get; set; }
    public double y { get; set; }

    public Point(double x, double y) {
        this.x = x;
        this.y = y;
    }

    public override void draw(Context ctx) {
        ctx.set_source_rgb(1.0, 0, 0);
        ctx.arc(x * zoom, y * zoom, 0.8, 0, 2.0 * 3.14);
        ctx.fill();
    }
}