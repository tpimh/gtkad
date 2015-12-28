using Cairo;

public class Canvas : Drawable {
    public override double x { get; set; }
    public override double y { get; set; }

    public double sx { get; set; }
    public double sy { get; set; }

    public Canvas(double sx, double sy) {
        this.sx = sx;
        this.sy = sy;
    }

    public override void draw(Context ctx) {
        ctx.set_source_rgb(1.0, 1.0, 1.0);
        ctx.translate(translate_x * zoom, translate_y * zoom);
        ctx.move_to(0, 0);
        ctx.rel_line_to(sx * zoom, 0);
        ctx.rel_line_to(0, sy * zoom);
        ctx.rel_line_to(-sx * zoom, 0);
        ctx.close_path();
        ctx.fill();

        ctx.set_source_rgba(0, 0, 1.0, 0.5);
        ctx.set_line_width(0.5);
        ctx.set_tolerance(0.1);
        for (double xx = 10.0; xx < sx; xx += 10) {
            ctx.move_to(xx * zoom, 0);
            ctx.line_to(xx * zoom, sy * zoom);
            ctx.stroke();
        }
        for (double yy = 10.0; yy < sy; yy += 10) {
            ctx.move_to(0, yy * zoom);
            ctx.line_to(sx * zoom, yy * zoom);
            ctx.stroke();
        }
    }
}
