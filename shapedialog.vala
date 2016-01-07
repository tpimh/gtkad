using Gtk;

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

    public ShapeDialog(Drawable d) {
        shape_dialog_vbox.pack_start(new Gtk.Label(GLib.Type.from_instance(d).name()), false, false, 0);
    }
}
