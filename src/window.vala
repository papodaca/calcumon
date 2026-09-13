public class Calcumon.Window : Adw.ApplicationWindow {
    private Adw.TabView tab_view;
    private PageStore store;
    private HashTable<SheetView, Page> sheet_pages;
    private uint save_timeout = 0;
    private SheetView? dirty_sheet;
    private bool restoring = false;

    public Window (Gtk.Application app) {
        Object (application: app);
    }

    construct {
        title = "Calcumon";
        default_width = 800;
        default_height = 600;
        sheet_pages = new HashTable<SheetView, Page> (direct_hash, direct_equal);
        store = new PageStore ();

        ActionEntry[] entries = {
            { "new-page", on_new_page },
            { "close-page", on_close_page_action },
            { "rename-page", on_rename_page },
            { "preferences", on_preferences },
            { "about", on_about },
            { "font-increase", on_font_increase },
            { "font-decrease", on_font_decrease },
        };
        add_action_entries (entries, this);

        try {
            var builder = new Gtk.Builder.from_resource ("/dev/calcumon/Calcumon/gtk/help-overlay.ui");
            set_help_overlay (builder.get_object ("help_overlay") as Gtk.ShortcutsWindow);
        } catch (Error e) {
            warning ("Could not load shortcuts overlay: %s", e.message);
        }

        tab_view = new Adw.TabView ();
        tab_view.hexpand = true;
        tab_view.vexpand = true;
        tab_view.close_page.connect (on_close_page);
        tab_view.notify["selected-page"].connect (on_selected_changed);
        tab_view.page_reordered.connect (() => {
            if (!restoring) {
                persist_session ();
            }
        });

        var menu = new Menu ();
        menu.append ("Rename", "win.rename-page");
        tab_view.menu_model = menu;

        var tab_bar = new Adw.TabBar ();
        tab_bar.view = tab_view;
        tab_bar.autohide = false;
        tab_bar.expand_tabs = false;
        tab_bar.hexpand = true;
        tab_bar.add_css_class ("inline");

        var new_btn = new Gtk.Button.from_icon_name ("tab-new-symbolic");
        new_btn.tooltip_text = "New page";
        new_btn.add_css_class ("flat");
        new_btn.clicked.connect (() => on_new_page (null, null));
        tab_bar.end_action_widget = new_btn;

        var click = new Gtk.GestureClick ();
        click.set_button (1);
        click.pressed.connect ((n_press, x, y) => {
            if (n_press != 2) {
                return;
            }
            if (pick_is_tab (tab_bar, x, y)) {
                on_rename_page (null, null);
            } else {
                click.set_state (Gtk.EventSequenceState.DENIED);
            }
        });
        tab_bar.add_controller (click);

        var header_menu = new Menu ();
        header_menu.append ("Preferences", "win.preferences");
        header_menu.append ("Keyboard Shortcuts", "win.show-help-overlay");
        header_menu.append ("About Calcumon", "win.about");
        var menu_btn = new Gtk.MenuButton ();
        menu_btn.icon_name = "open-menu-symbolic";
        menu_btn.tooltip_text = "Main menu";
        menu_btn.menu_model = header_menu;
        menu_btn.add_css_class ("flat");

        var header = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        header.add_css_class ("toolbar");
        header.append (new Gtk.WindowControls (Gtk.PackType.START));
        header.append (tab_bar);
        header.append (menu_btn);
        header.append (new Gtk.WindowControls (Gtk.PackType.END));

        var handle = new Gtk.WindowHandle ();
        handle.child = header;

        var toolbar_view = new Adw.ToolbarView ();
        toolbar_view.add_top_bar (handle);
        toolbar_view.content = tab_view;
        content = toolbar_view;

        close_request.connect (() => {
            flush_save ();
            return false;
        });

        restore_pages ();
    }

    public override void dispose () {
        if (save_timeout != 0) {
            Source.remove (save_timeout);
            save_timeout = 0;
        }
        base.dispose ();
    }

    private void restore_pages () {
        restoring = true;
        var pages = store.load_all ();
        if (pages.length == 0) {
            restoring = false;
            add_page_object (Page.empty (0), true);
            return;
        }

        Adw.TabPage? active = null;
        foreach (var page in pages) {
            var tab = add_page_object (page, false);
            if (store.active_id != null && page.id == store.active_id) {
                active = tab;
            }
        }
        if (active != null) {
            tab_view.selected_page = active;
        }
        restoring = false;
    }

    private Adw.TabPage add_page_object (Page page, bool persist) {
        var sheet = new SheetView ();
        sheet.text = page.text;
        sheet.content_changed.connect (() => schedule_save (sheet));
        sheet_pages.insert (sheet, page);

        var tab = tab_view.append (sheet);
        tab.title = page.title;
        tab_view.selected_page = tab;

        if (persist) {
            persist_page (page);
            persist_session ();
        }
        return tab;
    }

    private static bool pick_is_tab (Gtk.Widget root, double x, double y) {
        Gtk.Widget? widget = root.pick (x, y, Gtk.PickFlags.DEFAULT);
        while (widget != null && widget != root) {
            if (widget.css_name == "tab") {
                return true;
            }
            widget = widget.get_parent ();
        }
        return false;
    }

    private void on_new_page (SimpleAction? action, Variant? parameter) {
        add_page_object (Page.empty (tab_view.n_pages), true);
    }

    private void on_close_page_action (SimpleAction? action, Variant? parameter) {
        var selected = tab_view.get_selected_page ();
        if (selected != null) {
            tab_view.close_page (selected);
        }
    }

    private bool on_close_page (Adw.TabPage tab) {
        flush_save ();
        var sheet = tab.child as SheetView;
        if (sheet != null) {
            var page = sheet_pages.lookup (sheet);
            if (page != null) {
                try {
                    store.delete_id (page.id);
                } catch (Error e) {
                    warning ("Could not delete page: %s", e.message);
                }
                sheet_pages.remove (sheet);
            }
        }
        tab_view.close_page_finish (tab, true);
        if (tab_view.n_pages == 0) {
            add_page_object (Page.empty (0), true);
        } else {
            persist_session ();
        }
        return true;
    }

    private void on_rename_page (SimpleAction? action, Variant? parameter) {
        var tab = tab_view.get_selected_page ();
        if (tab == null) {
            return;
        }
        var sheet = tab.child as SheetView;
        if (sheet == null) {
            return;
        }
        var page = sheet_pages.lookup (sheet);
        if (page == null) {
            return;
        }

        var dialog = new Adw.AlertDialog ("Rename page", null);
        var entry = new Gtk.Entry ();
        entry.text = page.title;
        entry.activates_default = true;
        entry.hexpand = true;
        dialog.set_extra_child (entry);
        dialog.add_response ("cancel", "Cancel");
        dialog.add_response ("rename", "Rename");
        dialog.set_default_response ("rename");
        dialog.set_response_appearance ("rename", Adw.ResponseAppearance.SUGGESTED);
        dialog.response.connect ((id) => {
            if (id != "rename") {
                return;
            }
            var title = entry.text.strip ();
            if (title.length == 0) {
                title = "Page";
            }
            page.title = title;
            tab.title = title;
            persist_page (page);
        });
        dialog.present (this);
        entry.grab_focus ();
    }

    private void on_selected_changed () {
        if (restoring) {
            return;
        }
        flush_save ();
        persist_session ();
    }

    private void schedule_save (SheetView sheet) {
        if (restoring) {
            return;
        }
        dirty_sheet = sheet;
        if (save_timeout != 0) {
            Source.remove (save_timeout);
        }
        save_timeout = Timeout.add (500, () => {
            save_timeout = 0;
            persist_sheet (sheet);
            persist_session ();
            return Source.REMOVE;
        });
    }

    private void flush_save () {
        if (save_timeout == 0) {
            return;
        }
        Source.remove (save_timeout);
        save_timeout = 0;
        if (dirty_sheet != null) {
            persist_sheet (dirty_sheet);
            persist_session ();
        }
    }

    private void persist_sheet (SheetView sheet) {
        var page = sheet_pages.lookup (sheet);
        if (page == null) {
            return;
        }
        page.text = sheet.text;
        persist_page (page);
    }

    private void persist_page (Page page) {
        try {
            store.save (page);
        } catch (Error e) {
            warning ("Could not save page: %s", e.message);
        }
    }

    private void persist_session () {
        try {
            store.save_session (current_active_id (), current_ids ());
        } catch (Error e) {
            warning ("Could not save session: %s", e.message);
        }
    }

    private string? current_active_id () {
        var tab = tab_view.get_selected_page ();
        if (tab == null) {
            return null;
        }
        var sheet = tab.child as SheetView;
        if (sheet == null) {
            return null;
        }
        var page = sheet_pages.lookup (sheet);
        return page != null ? page.id : null;
    }

    private string[] current_ids () {
        var ids = new string[tab_view.n_pages];
        for (int i = 0; i < tab_view.n_pages; i++) {
            var sheet = tab_view.get_nth_page (i).child as SheetView;
            if (sheet == null) {
                ids[i] = "";
                continue;
            }
            var page = sheet_pages.lookup (sheet);
            ids[i] = page != null ? page.id : "";
            if (page != null) {
                page.order = (int) i;
            }
        }
        return ids;
    }

    private void on_preferences (SimpleAction? action, Variant? parameter) {
        var dialog = new Preferences ();
        dialog.present (this);
    }

    private void on_about (SimpleAction? action, Variant? parameter) {
        var about = new Adw.AboutDialog ();
        about.application_name = "Calcumon";
        about.application_icon = "dev.calcumon.Calcumon";
        about.developer_name = "Calcumon contributors";
        about.version = Config.VERSION;
        about.comments = "Notepad calculator. Expressions are evaluated with math.js.";
        about.developers = { "Calcumon contributors" };
        about.copyright = "© 2026 Calcumon contributors";
        about.license_type = Gtk.License.MIT_X11;
        about.present (this);
    }

    private void on_font_increase (SimpleAction? action, Variant? parameter) {
        AppSettings.get_default ().bump_font (1);
    }

    private void on_font_decrease (SimpleAction? action, Variant? parameter) {
        AppSettings.get_default ().bump_font (-1);
    }
}
