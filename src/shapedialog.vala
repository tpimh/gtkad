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
        Vector2D s = { da.get_allocated_width(), da.get_allocated_height() };
        double zoom = 1.0;

        new Canvas(s.x, s.y).draw(ctx, { 0, 0 }, zoom);

        drawable.draw(ctx, { -drawable.c.x + 100, -drawable.c.y + 100 }, zoom);

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
