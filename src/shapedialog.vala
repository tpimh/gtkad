using Gtk;
using Cairo;

[GtkTemplate(ui = "/org/golovin/gtkad/shapedialog.ui")]
public class ShapeDialog : Dialog {
    [GtkChild]
    public Box shape_dialog_vbox;

    [GtkChild]
    public ButtonBox shape_dialog_action_area;

    [GtkChild]
    public Button apply_button;

    [GtkChild]
    public Button cancel_button;

    [GtkChild]
    public Box shape_dialog_hbox;

    private Drawable drawable;

    [GtkChild]
    public DrawingArea drawing_area;

    [GtkCallback]
    public void on_cancel() {
        this.destroy();
    }

    [GtkCallback]
    public void on_apply() {

    }

    [GtkCallback]
    public bool on_draw(Widget da, Context ctx) {
        Vector2D visible_area = { da.get_allocated_width(), da.get_allocated_height() };

        double zoom = Math.fmin(visible_area.x, visible_area.y) / drawable.rs * 0.9;
        Vector2D s = { visible_area.x / zoom, visible_area.y / zoom };

        double cell_size = 10.0 * zoom; // modifications should be done according to cell size in canvas

        double a = (visible_area.x / 2) * (zoom - 1);
        while (a >= cell_size)
            a -= cell_size;

        Vector2D offset = { -a / zoom - (drawable.c.x % 10), -a / zoom - (drawable.c.y % 10) };

        new Canvas(s.x - offset.x, s.y - offset.y).draw(ctx, offset, zoom);

        drawable.draw(ctx, { -drawable.c.x + s.x / 2.0, -drawable.c.y + s.y / 2.0 }, zoom);

        return true;
    }

    public ShapeDialog(Drawable d) {
        drawable = d;

        Builder builder = new Builder.from_resource("/org/golovin/gtkad/options.ui");

        Widget options = builder.get_object(Type.from_instance(d).name() + "Options") as Widget;

        if (options == null) {
            options = new Gtk.Label(Type.from_instance(d).name() + ": " + d.id);
        }

        shape_dialog_hbox.pack_start(options, false, false, 0);
    }
}
