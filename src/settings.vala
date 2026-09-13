public class Calcumon.AppSettings : Object {
    private static AppSettings? instance;
    public Settings? settings { get; private set; }

    public static AppSettings get_default () {
        if (instance == null) {
            instance = new AppSettings ();
        }
        return instance;
    }

    public bool available {
        get {
            return settings != null;
        }
    }

    public int font_size {
        get {
            return settings != null ? settings.get_int ("font-size") : 14;
        }
        set {
            if (settings != null) {
                settings.set_int ("font-size", int.min (32, int.max (8, value)));
            }
        }
    }

    public bool show_line_numbers {
        get {
            return settings != null ? settings.get_boolean ("show-line-numbers") : true;
        }
        set {
            if (settings != null) {
                settings.set_boolean ("show-line-numbers", value);
            }
        }
    }

    public bool continue_from_previous {
        get {
            return settings != null ? settings.get_boolean ("continue-from-previous") : true;
        }
        set {
            if (settings != null) {
                settings.set_boolean ("continue-from-previous", value);
            }
        }
    }

    public int precision {
        get {
            return settings != null ? settings.get_int ("precision") : 4;
        }
        set {
            if (settings != null) {
                settings.set_int ("precision", int.min (16, int.max (0, value)));
            }
        }
    }

    private AppSettings () {
        var source = SettingsSchemaSource.get_default ();
        var schema = source.lookup ("dev.calcumon.Calcumon", true);
        if (schema == null) {
            warning ("GSettings schema dev.calcumon.Calcumon is missing; using defaults");
            return;
        }
        settings = new Settings.full (schema, null, null);
    }

    public void bump_font (int delta) {
        font_size = font_size + delta;
    }
}
