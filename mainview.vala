using Gtk;
using Cairo;

[GtkTemplate(ui = "/org/golovin/gtkad/mainview.ui")]
public class MainView : ApplicationWindow {
	[GtkChild]
	public HeaderBar header_bar;

	[GtkChild]
	public Scale zoom_scale;

	[GtkChild]
	public Adjustment zoom_adjustment;

    [GtkChild]
    public DrawingArea drawing_area;

    [GtkCallback]
    public static bool on_draw(Widget da, Context ctx) {
        new Canvas(200, 110).draw(ctx);
        new RegularPolygon(3, 10, 10, 3).draw(ctx);
        new RegularPolygon(4, 20, 10, 4).draw(ctx);
        new RegularPolygon(5, 30, 10, 5).draw(ctx);
        new RegularPolygon(6, 40, 10, 6).draw(ctx);
        new RegularPolygon(7, 50, 10, 7).draw(ctx);
        new RegularPolygon(8, 60, 10, 8).draw(ctx);

        return true;
    }

    [GtkCallback]
    public void on_zoom() {
        zoom = zoom_scale.get_value();
        drawing_area.queue_draw();
    }

    public MainView() {
        zoom_scale.add_mark(1.0, PositionType.BOTTOM, null);
    }
}
