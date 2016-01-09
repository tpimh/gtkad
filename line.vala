using Cairo;

public class Line : Drawable {
    public override Vector2D c { get; set; }

    // relative start and end
    public Vector2D start { get; set; }
    public Vector2D end { get; set; }

    // absolute start and end
    public Vector2D astart {
        owned get {
            return { c.x - start.x, c.y - start.y };
        }
        set {
        }
    }
    public Vector2D aend {
        owned get {
            return { c.x - end.x, c.y - end.y };
        }
        set {
        }
    }

    public double length { get; set; }
    public double rotation { get; set; }

    public override void draw(Context ctx) {
        ctx.set_source_rgb(0, 0, 0);
        ctx.set_line_width(0.5);
        ctx.set_tolerance(0.1);
        ctx.new_path();
        ctx.translate(c.x * zoom, c.y * zoom);

        ctx.move_to(start.x * zoom, start.y * zoom);
        ctx.line_to(end.x * zoom, end.y * zoom);

        ctx.close_path();
        ctx.stroke();

        /*start.draw(ctx);
        end.draw(ctx);*/

        ctx.translate(-c.x * zoom, -c.y * zoom);
    }

    public Line(double start_x, double start_y, double end_x, double end_y) {
        c = { (start_x + end_x) / 2, (start_y + end_y) / 2 };

        start = { c.x - start_x, c.y - start_y };
        end = { c.x - end_x, c.y - end_y };
    }

    public override string id {
        owned get {
            return @"L($astart;$aend)";
        }
    }
}
