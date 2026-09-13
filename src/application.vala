public class Calcumon.Application : Adw.Application {
    public Application () {
        Object (
            application_id: "dev.calcumon.Calcumon",
            flags: ApplicationFlags.DEFAULT_FLAGS,
            resource_base_path: "/dev/calcumon/Calcumon"
        );
    }

    construct {
        ActionEntry[] entries = {
            { "quit", on_quit },
        };
        add_action_entries (entries, this);
        set_accels_for_action ("app.quit", { "<primary>q" });
    }

    protected override void startup () {
        base.startup ();
        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("/dev/calcumon/Calcumon/style.css");
        Gtk.StyleContext.add_provider_for_display (
            Gdk.Display.get_default (),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );
    }

    protected override void activate () {
        var win = active_window;
        if (win == null) {
            win = new Calcumon.Window (this);
        }
        win.present ();
    }

    private void on_quit (SimpleAction action, Variant? parameter) {
        quit ();
    }
}
