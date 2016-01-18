using Cairo;

public class Canvas : Drawable {
    public override Vector2D c { get; set; }

    private Vector2D _s { get; set; }
    public override Vector2D s {
        get { return _s; }
    }

    public override double rs {
        get { return 0; } // canvas doesn't rotate
    }

    public Canvas(double sx, double sy) {
        _s = { sx, sy };
    }

    public override void draw(Context ctx, Vector2D translation, double zoom) {
        ctx.set_source_rgb(1.0, 1.0, 1.0);
        ctx.translate(translation.x * zoom, translation.y * zoom);
        ctx.move_to(0, 0);
        ctx.rel_line_to(s.x * zoom, 0);
        ctx.rel_line_to(0, s.y * zoom);
        ctx.rel_line_to(-s.x * zoom, 0);
        ctx.close_path();
        ctx.fill();

        ctx.set_source_rgba(0, 0, 1.0, 0.5);
        ctx.set_line_width(0.5);
        ctx.set_tolerance(0.1);
        for (double xx = 10.0; xx < s.x; xx += 10) {
            ctx.move_to(xx * zoom, 0);
            ctx.line_to(xx * zoom, s.y * zoom);
            ctx.stroke();
        }
        for (double yy = 10.0; yy < s.y; yy += 10) {
            ctx.move_to(0, yy * zoom);
            ctx.line_to(s.x * zoom, yy * zoom);
            ctx.stroke();
        }
        ctx.translate(-translation.x * zoom, -translation.y * zoom);
    }

    public override string id {
        owned get {
            return "C";
        }
    }
}
