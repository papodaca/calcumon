public class Calcumon.Window : Adw.ApplicationWindow {
    public Window (Gtk.Application app) {
        Object (application: app);
    }

    construct {
        title = "Calcumon";
        default_width = 800;
        default_height = 600;

        var header = new Adw.HeaderBar ();

        var source_view = new GtkSource.View ();
        source_view.monospace = true;
        source_view.show_line_numbers = true;
        source_view.hexpand = true;
        source_view.vexpand = true;
        source_view.wrap_mode = Gtk.WrapMode.WORD_CHAR;
        source_view.left_margin = 8;
        source_view.right_margin = 8;
        source_view.top_margin = 8;
        source_view.bottom_margin = 8;

        var scrolled = new Gtk.ScrolledWindow ();
        scrolled.set_child (source_view);
        scrolled.hexpand = true;
        scrolled.vexpand = true;

        var toolbar_view = new Adw.ToolbarView ();
        toolbar_view.add_top_bar (header);
        toolbar_view.content = scrolled;

        content = toolbar_view;
    }
}
