using Cairo;
using Gee;

public class RegularPolygon : Drawable {
    public double x { get; set; }
    public double y { get; set; }
    public uint n { get; set; }
    public double r { get; set; }
    public ArrayList<Point> points { get; set; }

    public RegularPolygon(uint n, double x, double y, double r) {
        this.x = x;
        this.y = y;
        this.n = n;
        points = new ArrayList<Point>();
        for (int i = 0; i < n; i++) {
            double d = 2 * Math.PI / n;
            points.add(new Point(
//  3 — 0.25
//  4 — 0.5
//  5 — 0.75
//  6 — 0
//  7 — 0.25
//  8 — 0.5
                Math.cos((i + 0.5) * d + Math.PI / 2) * r,
                Math.sin((i + 0.5) * d + Math.PI / 2) * r));
        }
    }

    public override void draw(Context ctx) {
        ctx.set_source_rgb(0, 0, 0);
        ctx.set_line_width(0.5);
        ctx.set_tolerance(0.1);
        ctx.new_path();
        ctx.translate(x * zoom, y * zoom);
        foreach (Point p in points) {
            if (p == points[0]) {
                ctx.move_to(p.x * zoom, p.y * zoom);
            } else {
                ctx.line_to(p.x * zoom, p.y * zoom);
            }
        }
        ctx.close_path();
        ctx.stroke();

        foreach (Point p in points) {
            p.draw(ctx);
        }

        ctx.translate(-x * zoom, -  y * zoom);
    }
}
