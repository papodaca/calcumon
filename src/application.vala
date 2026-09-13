public class Calcumon.Application : Adw.Application {
    public Application () {
        Object (
            application_id: "dev.calcumon.Calcumon",
            flags: ApplicationFlags.DEFAULT_FLAGS
        );
    }

    construct {
        ActionEntry[] entries = {
            { "quit", on_quit },
        };
        add_action_entries (entries, this);
        set_accels_for_action ("app.quit", { "<primary>q" });
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
