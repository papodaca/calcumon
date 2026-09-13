public class Calcumon.Window : Adw.ApplicationWindow {
    public Window (Gtk.Application app) {
        Object (application: app);
    }

    construct {
        title = "Calcumon";
        default_width = 800;
        default_height = 600;

        var header = new Adw.HeaderBar ();

        var sheet = new SheetView ();
        sheet.hexpand = true;
        sheet.vexpand = true;

        var toolbar_view = new Adw.ToolbarView ();
        toolbar_view.add_top_bar (header);
        toolbar_view.content = sheet;

        content = toolbar_view;
    }
}
