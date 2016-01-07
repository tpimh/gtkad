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
    public Box box;

    [GtkChild]
    public DrawingArea drawing_area;

    [GtkChild]
    public TreeView tree_view;

    [GtkChild]
    public TreeSelection tree_view_selection;

    [GtkChild]
    public TreeViewColumn tree_view_column;

    [GtkChild]
    public CellRendererText cell_renderer_text;

    [GtkChild]
    public Gtk.ListStore list_store;

    [GtkCallback]
    public bool on_draw(Widget da, Context ctx) {
        new Canvas(200, 110).draw(ctx);

        list_store.foreach((model, path, iter) => {
            Value drawable;

            list_store.get_value(iter, 1, out drawable);

            (drawable as Drawable).draw(ctx);
            return false;
        });

        return true;
    }

    [GtkCallback]
    public void on_zoom(Range range) {
        zoom = zoom_scale.get_value();
        drawing_area.queue_draw();
    }

    [GtkCallback]
    public void on_doubleclick(TreeView treeview, TreePath path, TreeViewColumn col) {
        TreeModel model;
        TreeIter iter;

        model = treeview.get_model();

        if (model.get_iter(out iter, path)) {
            Drawable drawable;
            model.get(iter, 1, out drawable, -1);

            new ShapeDialog(drawable).show_all();
        }
    }

    public MainView() {
        zoom_scale.add_mark(1.0, PositionType.BOTTOM, null);

        TreeIter iter;

        list_store.append(out iter);
        list_store.set(iter, 0, "Triangle", 1, new RegularPolygon(3, 50, 10, 3));
        list_store.append(out iter);
        list_store.set(iter, 0, "Square", 1, new RegularPolygon(4, 70, 10, 4));
        list_store.append(out iter);
        list_store.set(iter, 0, "Pentagon", 1, new RegularPolygon(5, 90, 10, 5));
        list_store.append(out iter);
        list_store.set(iter, 0, "Hexagon", 1, new RegularPolygon(6, 50, 30, 6));
        list_store.append(out iter);
        list_store.set(iter, 0, "Heptagon", 1, new RegularPolygon(7, 70, 30, 7));
        list_store.append(out iter);
        list_store.set(iter, 0, "Octagon", 1, new RegularPolygon(8, 90, 30, 8));
        list_store.append(out iter);
        list_store.set(iter, 0, "Line", 1, new Line(30, 30, 80, 50));
    }
}
