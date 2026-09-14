int main (string[] args) {
    var app = new Adw.Application ("dev.calcumon.Calcumon.Smoke", ApplicationFlags.NON_UNIQUE);
    int failed = 0;

    app.activate.connect (() => {
        var sheet = new Calcumon.SheetView ();
        var win = new Adw.ApplicationWindow (app);
        win.default_width = 800;
        win.default_height = 400;
        win.content = sheet;
        win.present ();

        run_case (sheet, "1+2", (got) => got.strip () == "3", "1+2 => 3", ref failed);
        run_case (sheet, "a = 5\na^2", (got) => got == "5\n25", "a=5 / a^2", ref failed);
        run_case (sheet, "1 +", (got) => got.strip () == "Error", "1 + is Error", ref failed);
        run_case (sheet, "10% of 20", (got) => got.strip () == "2", "10% of 20 => 2", ref failed);
        run_case (sheet, "# heading", (got) => got.strip () == "", "comment is empty", ref failed);

        win.close ();
        app.quit ();
    });

    app.run (args);
    if (failed > 0) {
        stderr.printf ("%d sheet smoke test(s) failed\n", failed);
        return 1;
    }
    stdout.printf ("sheet smoke tests passed\n");
    return 0;
}

delegate bool Check (string got);

void pump (uint ms) {
    var done = false;
    Timeout.add (ms, () => {
        done = true;
        return Source.REMOVE;
    });
    var ctx = MainContext.default ();
    while (!done) {
        ctx.iteration (true);
    }
}

void run_case (Calcumon.SheetView sheet, string source, Check check, string name, ref int failed) {
    sheet.text = source;
    pump (120);
    if (!check (sheet.results_text)) {
        stderr.printf ("FAIL %s: got '%s'\n", name, sheet.results_text.replace ("\n", "\\n"));
        failed++;
    }
}
