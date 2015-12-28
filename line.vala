using Cairo;

public class Line : Drawable {
    public double start_x { get; set; }
    public double start_y { get; set; }

    public double end_x { get; set; }
    public double end_y { get; set; }

    public double override x { get; set; }
    public double override y { get; set; }

    public double length { get; set; }
    public double rotation { get; set; }

    public override void draw(Context ctx) {
        //TODO
    }
}
