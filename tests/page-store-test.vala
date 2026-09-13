int main (string[] args) {
    string tmp;
    try {
        tmp = DirUtils.make_tmp ("calcumon-pages-XXXXXX");
    } catch (Error e) {
        stderr.printf ("temp dir: %s\n", e.message);
        return 1;
    }

    var store = new Calcumon.PageStore.with_base (File.new_for_path (tmp));
    int failed = 0;

    var rent = new Calcumon.Page ("id-rent", "Rent", "1200 + 250\n", 0);
    var food = new Calcumon.Page ("id-food", "Food", "a = 3\na * 2", 1);
    try {
        store.save (rent);
        store.save (food);
        store.save_session ("id-food", { "id-rent", "id-food" });
    } catch (Error e) {
        stderr.printf ("save failed: %s\n", e.message);
        return 1;
    }

    var loaded_store = new Calcumon.PageStore.with_base (File.new_for_path (tmp));
    var loaded = loaded_store.load_all ();
    if (loaded.length != 2) {
        stderr.printf ("FAIL load count: %d\n", loaded.length);
        failed++;
    } else {
        if (loaded[0].id != "id-rent" || loaded[0].title != "Rent" || loaded[0].text != "1200 + 250\n") {
            stderr.printf ("FAIL first page: %s %s %s\n", loaded[0].id, loaded[0].title, loaded[0].text);
            failed++;
        }
        if (loaded[1].id != "id-food" || loaded[1].title != "Food") {
            stderr.printf ("FAIL second page title\n");
            failed++;
        }
        if (loaded_store.active_id != "id-food") {
            stderr.printf ("FAIL active_id=%s\n", loaded_store.active_id);
            failed++;
        }
    }

    try {
        File.new_for_path (Path.build_filename (tmp, "pages", "bad.json")).replace_contents (
            "{not json".data, null, false, FileCreateFlags.NONE, null
        );
        store.save_session ("id-rent", { "id-rent", "missing", "id-food" });
        var skipped = new Calcumon.PageStore.with_base (File.new_for_path (tmp)).load_all ();
        if (skipped.length != 2 || skipped[0].id != "id-rent" || skipped[1].id != "id-food") {
            stderr.printf ("FAIL skip missing/corrupt: got %d\n", skipped.length);
            failed++;
        }
    } catch (Error e) {
        stderr.printf ("FAIL corrupt setup: %s\n", e.message);
        failed++;
    }

    try {
        store.delete_id ("id-food");
        store.save_session ("id-rent", { "id-rent" });
        var after = new Calcumon.PageStore.with_base (File.new_for_path (tmp)).load_all ();
        if (after.length != 1 || after[0].id != "id-rent") {
            stderr.printf ("FAIL delete: %d pages\n", after.length);
            failed++;
        }
    } catch (Error e) {
        stderr.printf ("FAIL delete: %s\n", e.message);
        failed++;
    }

    try {
        DirUtils.remove (Path.build_filename (tmp, "pages", "id-rent.json"));
        DirUtils.remove (Path.build_filename (tmp, "pages", "bad.json"));
        DirUtils.remove (Path.build_filename (tmp, "pages"));
        File.new_for_path (Path.build_filename (tmp, "session.json")).delete ();
        DirUtils.remove (tmp);
    } catch (Error e) {
        warning ("cleanup: %s", e.message);
    }

    if (failed > 0) {
        stderr.printf ("%d page-store test(s) failed\n", failed);
        return 1;
    }
    stdout.printf ("page-store tests passed\n");
    return 0;
}
