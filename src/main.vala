using Gtk;

public static int main(string[] args) {
	Gtk.init(ref args);

	var view = new MainView();
	view.show_all();

	Gtk.main();

    return 0;
}
