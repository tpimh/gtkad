using Cairo;

public class Line : Drawable {
    public Point start { get; set; }
    public Point end { get; set; }

    public override double x { get; set; }
    public override double y { get; set; }

    public double length { get; set; }
    public double rotation { get; set; }

    public override void draw(Context ctx) {
        ctx.set_source_rgb(0, 0, 0);
        ctx.set_line_width(0.5);
        ctx.set_tolerance(0.1);
        ctx.new_path();
        ctx.translate(x * zoom, y * zoom);

        ctx.move_to(start.x * zoom, start.y * zoom);
        ctx.line_to(end.x * zoom, end.y * zoom);

        ctx.close_path();
        ctx.stroke();

        start.draw(ctx);
        end.draw(ctx);

        ctx.translate(-x * zoom, -y * zoom);
    }

    public Line(double start_x, double start_y, double end_x, double end_y) {
        x = (start_x + end_x) / 2;
        y = (start_y + end_y) / 2;

        start = new Point(x - start_x, y - start_y);
        end = new Point(x - end_x, y - end_y);
    }
}
