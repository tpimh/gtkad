using Cairo;

public class Line : Drawable {
    public Point start { get; set; }
    public Point end { get; set; }

    public override double x { get; set; }
    public override double y { get; set; }

    public double length { get; set; }
    public double rotation { get; set; }

    public override void draw(Context ctx) {
        //TODO
    }

    public Line(double start_x, double start_y, double end_x, double end_y) {
        //TODO
    }
}
