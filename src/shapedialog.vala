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
        double lzoom = 1.0;

        ctx.set_source_rgb(1.0, 1.0, 1.0);
        ctx.move_to(0, 0);
        ctx.rel_line_to(s.x * lzoom, 0);
        ctx.rel_line_to(0, s.y * lzoom);
        ctx.rel_line_to(-s.x * lzoom, 0);
        ctx.close_path();
        ctx.fill();

        ctx.set_source_rgba(0, 0, 1.0, 0.5);
        ctx.set_line_width(0.5);
        ctx.set_tolerance(0.1);
        for (double xx = 10.0; xx < s.x; xx += 10) {
            ctx.move_to(xx * lzoom, 0);
            ctx.line_to(xx * lzoom, s.y * lzoom);
            ctx.stroke();
        }
        for (double yy = 10.0; yy < s.y; yy += 10) {
            ctx.move_to(0, yy * lzoom);
            ctx.line_to(s.x * lzoom, yy * lzoom);
            ctx.stroke();
        }

        return true;
    }

    public ShapeDialog(Drawable d) {
        Builder builder = new Builder.from_resource("/org/golovin/gtkad/options.ui");

        Widget options = builder.get_object(Type.from_instance(d).name() + "Options") as Widget;

        if (options == null) {
            options = new Gtk.Label(Type.from_instance(d).name() + ": " + d.id);
        }

        shape_dialog_hbox.pack_start(options, false, false, 0);
    }
}
