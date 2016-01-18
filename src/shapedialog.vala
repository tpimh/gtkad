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

    [GtkCallback]
    public void on_cancel() {
        this.destroy();
    }

    [GtkCallback]
    public void on_apply() {

    }

    public ShapeDialog(Drawable d) {
        Builder builder = new Builder.from_resource("/org/golovin/gtkad/options.ui");

        Widget options = builder.get_object(Type.from_instance(d).name() + "Options") as Widget;

        if (options == null) {
            options = new Gtk.Label(Type.from_instance(d).name() + ": " + d.id);
        }

        shape_dialog_vbox.pack_start(options, false, false, 0);
    }
}
