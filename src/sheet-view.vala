public class Calcumon.SheetView : Gtk.Box {
    public GtkSource.View editor { get; private set; }
    private Gtk.TextView? results_view;
    private Gtk.ScrolledWindow? editor_scroll;
    private Gtk.ScrolledWindow? results_scroll;
    private Gtk.Paned? paned;
    private Gtk.TextTag? error_tag;
    private SheetEngine? engine;
    private LineResult[] last_results = {};
    private uint debounce_id = 0;
    private ulong dark_handler = 0;
    private ulong settings_handler = 0;
    private Gtk.CssProvider? font_css;
    private bool split_placed = false;

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
    public signal void copied ();

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

        results_view.has_tooltip = true;
        results_view.query_tooltip.connect (on_query_tooltip);
        var copy_click = new Gtk.GestureClick ();
        copy_click.set_button (1);
        copy_click.released.connect (on_copy_click);
        results_view.add_controller (copy_click);

        editor_scroll = new Gtk.ScrolledWindow ();
        editor_scroll.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        editor_scroll.has_frame = false;
        editor_scroll.hexpand = true;
        editor_scroll.vexpand = true;
        editor_scroll.width_request = 160;
        editor_scroll.set_child (editor);

        results_scroll = new Gtk.ScrolledWindow ();
        results_scroll.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.NEVER);
        results_scroll.has_frame = false;
        results_scroll.hexpand = true;
        results_scroll.vexpand = true;
        results_scroll.set_child (results_view);
        results_scroll.set_vadjustment (editor_scroll.get_vadjustment ());

        paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        paned.add_css_class ("sheet-paned");
        paned.hexpand = true;
        paned.vexpand = true;
        paned.wide_handle = true;
        paned.resize_start_child = true;
        paned.resize_end_child = false;
        paned.shrink_start_child = false;
        paned.shrink_end_child = false;
        paned.start_child = editor_scroll;
        paned.end_child = results_scroll;
        append (paned);

        map.connect (sync_theme);
        dark_handler = Adw.StyleManager.get_default ().notify["dark"].connect (sync_theme);

        editor.buffer.changed.connect (on_buffer_changed);
        map.connect (() => {
            Idle.add (() => {
                place_split_once ();
                return Source.REMOVE;
            });
        });
        var app_settings = AppSettings.get_default ();
        if (app_settings.settings != null) {
            settings_handler = app_settings.settings.changed.connect ((key) => apply_settings ());
        }
        apply_settings ();
        sync_theme ();
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
        if (settings_handler != 0 && AppSettings.get_default ().settings != null) {
            AppSettings.get_default ().settings.disconnect (settings_handler);
            settings_handler = 0;
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
        last_results = engine.evaluate (editor.buffer.text);
        var builder = new StringBuilder ();
        for (int i = 0; i < last_results.length; i++) {
            if (i > 0) {
                builder.append_c ('\n');
            }
            if (last_results[i].kind == LineKind.ERROR) {
                builder.append ("Error");
            } else {
                builder.append (last_results[i].text);
            }
        }

        var buf = results_view.buffer;
        buf.set_text (builder.str, -1);

        for (int i = 0; i < last_results.length; i++) {
            if (last_results[i].kind != LineKind.ERROR) {
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

    private bool on_query_tooltip (int x, int y, bool keyboard_tooltip, Gtk.Tooltip tooltip) {
        if (keyboard_tooltip || last_results.length == 0) {
            return false;
        }
        int line = line_at (x, y);
        if (line < 0 || line >= last_results.length) {
            return false;
        }
        if (last_results[line].kind != LineKind.ERROR) {
            return false;
        }
        tooltip.set_text (last_results[line].text);
        return true;
    }

    private void on_copy_click (int n_press, double x, double y) {
        if (n_press != 1 || last_results.length == 0) {
            return;
        }
        int line = line_at ((int) x, (int) y);
        if (line < 0 || line >= last_results.length) {
            return;
        }
        var result = last_results[line];
        if (result.kind == LineKind.EMPTY || result.text.length == 0) {
            return;
        }
        results_view.get_clipboard ().set_text (result.text);
        copied ();
    }

    private int line_at (int x, int y) {
        int bx;
        int by;
        results_view.window_to_buffer_coords (Gtk.TextWindowType.WIDGET, x, y, out bx, out by);
        Gtk.TextIter iter;
        results_view.get_iter_at_location (out iter, bx, by);
        return iter.get_line ();
    }

    private int result_char_width () {
        if (results_view == null) {
            return 8;
        }
        var layout = results_view.create_pango_layout ("0");
        int width;
        int height;
        layout.get_pixel_size (out width, out height);
        return width > 0 ? width : 8;
    }

    private void update_result_min_width () {
        if (results_scroll == null) {
            return;
        }
        results_scroll.width_request = result_char_width () * 8;
    }

    private void place_split_once () {
        update_result_min_width ();
        if (split_placed || paned == null) {
            return;
        }
        int total = paned.get_width ();
        if (total < 2) {
            return;
        }
        int results_w = result_char_width () * 16;
        if (results_w < 140) {
            results_w = 140;
        }
        paned.position = int.max (160, total - results_w);
        split_placed = true;
    }

    private void apply_settings () {
        if (editor == null || results_view == null || engine == null) {
            return;
        }
        var s = AppSettings.get_default ();
        editor.show_line_numbers = s.show_line_numbers;
        editor.wrap_mode = Gtk.WrapMode.NONE;
        engine.precision = s.precision;
        engine.continue_from_previous = s.continue_from_previous;
        apply_font (s.font_size);
        recompute ();
        update_result_min_width ();
    }

    private void apply_font (int pt) {
        if (font_css == null) {
            font_css = new Gtk.CssProvider ();
            editor.get_style_context ().add_provider (font_css, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
            results_view.get_style_context ().add_provider (font_css, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
        }
        font_css.load_from_string (".sheet-editor, .sheet-results { font-size: %dpt; }".printf (pt));
    }

    private void sync_theme () {
        var dark = Adw.StyleManager.get_default ().dark;
        if (error_tag != null) {
            error_tag.foreground = dark ? "#f66151" : "#c01c28";
        }
        var buffer = editor != null ? editor.buffer as GtkSource.Buffer : null;
        if (buffer == null) {
            return;
        }
        var manager = GtkSource.StyleSchemeManager.get_default ();
        string[] ids;
        if (dark) {
            ids = { "Adwaita-dark", "oblivion", "solarized-dark" };
        } else {
            ids = { "Adwaita", "classic", "kate" };
        }
        GtkSource.StyleScheme? scheme = null;
        foreach (var id in ids) {
            scheme = manager.get_scheme (id);
            if (scheme != null) {
                break;
            }
        }
        if (scheme != null) {
            buffer.style_scheme = scheme;
        }
    }
}
