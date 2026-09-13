public class Calcumon.Preferences : Adw.PreferencesDialog {
    public Preferences () {
        title = "Preferences";

        var app_settings = AppSettings.get_default ();

        var editor_page = new Adw.PreferencesPage ();
        editor_page.title = "Editor";
        editor_page.icon_name = "text-editor-symbolic";

        var editor_group = new Adw.PreferencesGroup ();
        var font_row = new Adw.SpinRow.with_range (8, 32, 1);
        font_row.title = "Font size";
        font_row.digits = 0;
        font_row.value = app_settings.font_size;
        font_row.notify["value"].connect (() => {
            app_settings.font_size = (int) font_row.value;
        });
        if (app_settings.settings != null) {
            app_settings.settings.changed["font-size"].connect (() => {
                if ((int) font_row.value != app_settings.font_size) {
                    font_row.value = app_settings.font_size;
                }
            });
        }

        var numbers_row = new Adw.SwitchRow ();
        numbers_row.title = "Line numbers";
        numbers_row.active = app_settings.show_line_numbers;
        if (app_settings.settings != null) {
            app_settings.settings.bind ("show-line-numbers", numbers_row, "active", SettingsBindFlags.DEFAULT);
        }

        // Wrapping the editor makes a wrapped source line occupy more height than
        // its single answer row, so pairing breaks. Keep wrap off until that is solved.
        var wrap_row = new Adw.SwitchRow ();
        wrap_row.title = "Wrap input";
        wrap_row.subtitle = "Off because wrap breaks alignment with answers";
        wrap_row.active = false;
        wrap_row.sensitive = false;

        editor_group.add (font_row);
        editor_group.add (numbers_row);
        editor_group.add (wrap_row);
        editor_page.add (editor_group);

        var calc_page = new Adw.PreferencesPage ();
        calc_page.title = "Calculator";
        calc_page.icon_name = "accessories-calculator-symbolic";

        var calc_group = new Adw.PreferencesGroup ();
        var continue_row = new Adw.SwitchRow ();
        continue_row.title = "Continue from previous";
        continue_row.subtitle = "A line starting with +, -, *, or / uses the previous answer";
        continue_row.active = app_settings.continue_from_previous;
        if (app_settings.settings != null) {
            app_settings.settings.bind ("continue-from-previous", continue_row, "active", SettingsBindFlags.DEFAULT);
        }

        var precision_row = new Adw.SpinRow.with_range (0, 16, 1);
        precision_row.title = "Precision";
        precision_row.subtitle = "Digits after the decimal for non-integers";
        precision_row.digits = 0;
        precision_row.value = app_settings.precision;
        precision_row.notify["value"].connect (() => {
            app_settings.precision = (int) precision_row.value;
        });
        if (app_settings.settings != null) {
            app_settings.settings.changed["precision"].connect (() => {
                if ((int) precision_row.value != app_settings.precision) {
                    precision_row.value = app_settings.precision;
                }
            });
        }

        calc_group.add (continue_row);
        calc_group.add (precision_row);
        calc_page.add (calc_group);

        add (editor_page);
        add (calc_page);
    }
}
