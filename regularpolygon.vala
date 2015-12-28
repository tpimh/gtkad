using Cairo;
using Gee;

public class RegularPolygon : Drawable {
    public override double x { get; set; }
    public override double y { get; set; }
    public uint n { get; set; }
    public double r { get; set; }
    public ArrayList<Point> points { get; set; }

    public RegularPolygon(uint n, double x, double y, double r) {
        this.x = x;
        this.y = y;
        this.n = n;
        double alpha = 2 * Math.PI / n;
        points = new ArrayList<Point>();
        for (int i = 0; i < n; i++) {
            double beta = (i + 0.5) * alpha + Math.PI / 2;
            points.add(new Point(
                Math.cos(beta) * r,
                Math.sin(beta) * r));
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
