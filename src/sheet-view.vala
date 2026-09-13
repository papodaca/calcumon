public class Calcumon.SheetView : Gtk.Box {
    public GtkSource.View editor { get; private set; }
    private Gtk.TextView? results_view;
    private Gtk.ScrolledWindow? editor_scroll;
    private Gtk.ScrolledWindow? results_scroll;
    private Gtk.TextTag? error_tag;
    private SheetEngine? engine;
    private uint debounce_id = 0;
    private ulong dark_handler = 0;

    public string text {
        owned get {
            if (editor == null) {
                return "";
            }
            return editor.buffer.text;
        }
        set {
            if (editor == null) {
                return;
            }
            editor.buffer.set_text (value, -1);
        }
    }

    public string results_text {
        owned get {
            if (results_view == null) {
                return "";
            }
            return results_view.buffer.text;
        }
    }

    public signal void content_changed ();

    public SheetView () {
        Object (orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);
    }

    construct {
        hexpand = true;
        vexpand = true;

        try {
            engine = new SheetEngine ();
        } catch (Error e) {
            var status = new Adw.StatusPage ();
            status.title = "Could not load math.js";
            status.description = e.message;
            status.icon_name = "dialog-error-symbolic";
            status.hexpand = true;
            status.vexpand = true;
            append (status);
            return;
        }

        editor = new GtkSource.View ();
        editor.add_css_class ("sheet-editor");
        editor.monospace = true;
        editor.show_line_numbers = true;
        editor.hexpand = true;
        editor.vexpand = true;
        editor.wrap_mode = Gtk.WrapMode.NONE;
        editor.left_margin = 8;
        editor.right_margin = 8;
        editor.top_margin = 8;
        editor.bottom_margin = 8;
        editor.pixels_above_lines = 2;
        editor.pixels_below_lines = 2;

        results_view = new Gtk.TextView ();
        results_view.add_css_class ("sheet-results");
        results_view.monospace = true;
        results_view.editable = false;
        results_view.cursor_visible = false;
        results_view.can_focus = false;
        results_view.hexpand = true;
        results_view.vexpand = true;
        results_view.wrap_mode = Gtk.WrapMode.NONE;
        results_view.justification = Gtk.Justification.RIGHT;
        results_view.left_margin = 12;
        results_view.right_margin = 12;
        results_view.top_margin = editor.top_margin;
        results_view.bottom_margin = editor.bottom_margin;
        results_view.pixels_above_lines = editor.pixels_above_lines;
        results_view.pixels_below_lines = editor.pixels_below_lines;

        error_tag = results_view.buffer.create_tag ("error");

        editor_scroll = new Gtk.ScrolledWindow ();
        editor_scroll.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        editor_scroll.has_frame = false;
        editor_scroll.hexpand = true;
        editor_scroll.vexpand = true;
        editor_scroll.set_child (editor);

        results_scroll = new Gtk.ScrolledWindow ();
        results_scroll.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.NEVER);
        results_scroll.has_frame = false;
        results_scroll.hexpand = true;
        results_scroll.vexpand = true;
        results_scroll.width_request = 140;
        results_scroll.set_child (results_view);
        results_scroll.set_vadjustment (editor_scroll.get_vadjustment ());

        var separator = new Gtk.Separator (Gtk.Orientation.VERTICAL);

        append (editor_scroll);
        append (separator);
        append (results_scroll);

        map.connect (sync_error_color);
        dark_handler = Adw.StyleManager.get_default ().notify["dark"].connect (sync_error_color);

        editor.buffer.changed.connect (on_buffer_changed);
        realize.connect (update_result_width);
        recompute ();
    }

    public override void dispose () {
        if (debounce_id != 0) {
            Source.remove (debounce_id);
            debounce_id = 0;
        }
        if (dark_handler != 0) {
            Adw.StyleManager.get_default ().disconnect (dark_handler);
            dark_handler = 0;
        }
        base.dispose ();
    }

    private void on_buffer_changed () {
        content_changed ();
        if (debounce_id != 0) {
            Source.remove (debounce_id);
        }
        debounce_id = Timeout.add (50, () => {
            debounce_id = 0;
            recompute ();
            return Source.REMOVE;
        });
    }

    private void recompute () {
        if (engine == null) {
            return;
        }

        var vadj = editor_scroll.vadjustment;
        double scroll = vadj.value;
        var results = engine.evaluate (editor.buffer.text);
        var builder = new StringBuilder ();
        for (int i = 0; i < results.length; i++) {
            if (i > 0) {
                builder.append_c ('\n');
            }
            builder.append (results[i].text);
        }

        var buf = results_view.buffer;
        buf.set_text (builder.str, -1);

        for (int i = 0; i < results.length; i++) {
            if (results[i].kind != LineKind.ERROR) {
                continue;
            }
            Gtk.TextIter line_start;
            buf.get_iter_at_line (out line_start, i);
            var line_end = line_start;
            if (!line_end.ends_line ()) {
                line_end.forward_to_line_end ();
            }
            buf.apply_tag (error_tag, line_start, line_end);
        }

        vadj.value = scroll;
        results_scroll.set_vadjustment (editor_scroll.get_vadjustment ());
    }

    private void update_result_width () {
        var layout = results_view.create_pango_layout ("0");
        int width;
        int height;
        layout.get_pixel_size (out width, out height);
        if (width <= 0) {
            width = 8;
        }
        results_scroll.width_request = width * 16;
    }

    private void sync_error_color () {
        if (Adw.StyleManager.get_default ().dark) {
            error_tag.foreground = "#f66151";
        } else {
            error_tag.foreground = "#c01c28";
        }
    }
}
