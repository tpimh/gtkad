using Cairo;
using Gee;

public class RegularPolygon : Drawable {
    public override Vector2D c { get; set; }
    public uint n { get; set; }
    public double r { get; set; }
    public ArrayList<Vector2D?> points { get; set; }

    public RegularPolygon(uint n, double x, double y, double r) {
        c = { x, y };
        this.r = r;
        this.n = n;
        double alpha = 2 * Math.PI / n;
        points = new ArrayList<Vector2D?>();
        for (int i = 0; i < n; i++) {
            double beta = (i + 0.5) * alpha + Math.PI / 2;
            points.add({ Math.cos(beta) * r, Math.sin(beta) * r });
        }
    }

    public override void draw(Context ctx) {
        ctx.set_source_rgb(0, 0, 0);
        ctx.set_line_width(0.5);
        ctx.set_tolerance(0.1);
        ctx.new_path();
        ctx.translate(c.x * zoom, c.y * zoom);
        foreach (Vector2D p in points) {
            if (p == points[0]) {
                ctx.move_to(p.x * zoom, p.y * zoom);
            } else {
                ctx.line_to(p.x * zoom, p.y * zoom);
            }
        }
        ctx.close_path();
        ctx.stroke();

        /*foreach (Point p in points) {
            p.draw(ctx);
        }*/

        ctx.translate(-c.x * zoom, -c.y * zoom);
    }

    public override string id {
        owned get {
            return @"RP$n($c;$r)";
        }
    }
}
