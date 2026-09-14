int main (string[] args) {
    Calcumon.SheetEngine engine;
    try {
        engine = new Calcumon.SheetEngine ();
    } catch (Error e) {
        stderr.printf ("init failed: %s\n", e.message);
        return 1;
    }

    int failed = 0;
    failed += expect_answer (engine, "1 + 2", "3");
    failed += expect_sheet (engine, "a = 2\na * 3", {
        want (1, Calcumon.LineKind.ANSWER, "2"),
        want (2, Calcumon.LineKind.ANSWER, "6")
    });
    failed += expect_answer (engine, "1 + 2 // add", "3");
    failed += expect_empty (engine, "# heading");
    failed += expect_sheet (engine, "1+1\n\n2+2", {
        want (1, Calcumon.LineKind.ANSWER, "2"),
        want (2, Calcumon.LineKind.EMPTY, ""),
        want (3, Calcumon.LineKind.ANSWER, "4")
    });
    failed += expect_unit (engine, "5 cm + 2 in");
    failed += expect_error (engine, "1 +");
    failed += expect_near (engine, "sin(pi/2)", 1.0);
    failed += expect_sheet (engine, "a = 5\na * 3", {
        want (1, Calcumon.LineKind.ANSWER, "5"),
        want (2, Calcumon.LineKind.ANSWER, "15")
    });
    failed += expect_sheet (engine, "10\n20\nans\nline1\ntotal", {
        want (1, Calcumon.LineKind.ANSWER, "10"),
        want (2, Calcumon.LineKind.ANSWER, "20"),
        want (3, Calcumon.LineKind.ANSWER, "20"),
        want (4, Calcumon.LineKind.ANSWER, "10"),
        want (5, Calcumon.LineKind.ANSWER, "60")
    });
    failed += expect_sheet (engine, "10\n20\n\n30\nsubtotal\ntotal", {
        want (1, Calcumon.LineKind.ANSWER, "10"),
        want (2, Calcumon.LineKind.ANSWER, "20"),
        want (3, Calcumon.LineKind.EMPTY, ""),
        want (4, Calcumon.LineKind.ANSWER, "30"),
        want (5, Calcumon.LineKind.ANSWER, "30"),
        want (6, Calcumon.LineKind.ANSWER, "60")
    });
    failed += expect_sheet (engine, "10\n20\navg", {
        want (1, Calcumon.LineKind.ANSWER, "10"),
        want (2, Calcumon.LineKind.ANSWER, "20"),
        want (3, Calcumon.LineKind.ANSWER, "15")
    });
    failed += expect_sheet (engine, "100\n+ 20\n* 2", {
        want (1, Calcumon.LineKind.ANSWER, "100"),
        want (2, Calcumon.LineKind.ANSWER, "120"),
        want (3, Calcumon.LineKind.ANSWER, "240")
    });
    failed += expect_sheet (engine, "10\n# keep\n20\nsubtotal", {
        want (1, Calcumon.LineKind.ANSWER, "10"),
        want (2, Calcumon.LineKind.EMPTY, ""),
        want (3, Calcumon.LineKind.ANSWER, "20"),
        want (4, Calcumon.LineKind.ANSWER, "30")
    });
    failed += expect_error (engine, "line4");
    failed += expect_error (engine, "ans");
    failed += expect_error (engine, "ans = 5");
    engine.continue_from_previous = false;
    failed += expect_sheet (engine, "100\n+ 20", {
        want (1, Calcumon.LineKind.ANSWER, "100"),
        want (2, Calcumon.LineKind.ANSWER, "20")
    });
    engine.continue_from_previous = true;
    failed += expect_kind (engine, "10\n5 cm\ntotal", 3, Calcumon.LineKind.ERROR);

    failed += expect_answer (engine, "10% of 20", "2");
    failed += expect_answer (engine, "40 + 5%", "42");
    failed += expect_answer (engine, "8 % 3", "2");
    failed += expect_answer (engine, "100%", "1");
    failed += expect_answer (engine, "10% of (5+5)", "1");
    failed += expect_error (engine, "today = 1");
    failed += expect_error (engine, "now = 1");
    failed += expect_kind (engine, "today", 1, Calcumon.LineKind.ANSWER);
    failed += expect_kind (engine, "now", 1, Calcumon.LineKind.ANSWER);
    failed += expect_same_text (engine, "today\ntoday + 1 day - 1 day");
    failed += expect_date_days (engine, "today\ntoday + 7 days", 1, 2, 7);
    failed += expect_date_days (engine, "today\ntoday + 3 weeks", 1, 2, 21);
    failed += expect_date_ms (engine, "now\nnow + 1 hour", 1, 2, 3600 * 1000);
    failed += expect_date_days (engine, "tmrw = today + 1 day\ntmrw", 1, 2, 0);
    failed += expect_date_days (engine, "today\ntmrw = today + 1 day\ntmrw", 1, 3, 1);
    {
        var today_text = engine.evaluate ("today")[0].text;
        failed += expect_sheet (engine, "10\ntoday\n20\ntotal", {
            want (1, Calcumon.LineKind.ANSWER, "10"),
            want (2, Calcumon.LineKind.ANSWER, today_text),
            want (3, Calcumon.LineKind.ANSWER, "20"),
            want (4, Calcumon.LineKind.ANSWER, "30")
        });
    }

    if (failed > 0) {
        stderr.printf ("%d test(s) failed\n", failed);
        return 1;
    }
    stdout.printf ("engine tests passed\n");
    return 0;
}

Calcumon.LineResult want (int line, Calcumon.LineKind kind, string text) {
    return new Calcumon.LineResult (line, kind, text);
}

int expect_answer (Calcumon.SheetEngine engine, string source, string text) {
    return expect_sheet (engine, source, {
        want (1, Calcumon.LineKind.ANSWER, text)
    });
}

int expect_empty (Calcumon.SheetEngine engine, string source) {
    return expect_sheet (engine, source, {
        want (1, Calcumon.LineKind.EMPTY, "")
    });
}

int expect_kind (Calcumon.SheetEngine engine, string source, int line, Calcumon.LineKind kind) {
    var got = engine.evaluate (source);
    if (line < 1 || line > got.length || got[line - 1].kind != kind) {
        stderr.printf ("FAIL kind %s line %d: got %s\n",
            describe (source), line,
            line >= 1 && line <= got.length ? kind_name (got[line - 1].kind) : "missing");
        return 1;
    }
    return 0;
}

int expect_error (Calcumon.SheetEngine engine, string source) {
    var got = engine.evaluate (source);
    if (got.length != 1 || got[0].kind != Calcumon.LineKind.ERROR || got[0].text.length == 0) {
        stderr.printf ("FAIL error %s: kind=%s text=%s\n",
            source, kind_name (got.length > 0 ? got[0].kind : Calcumon.LineKind.EMPTY),
            got.length > 0 ? got[0].text : "");
        return 1;
    }
    return 0;
}

int expect_unit (Calcumon.SheetEngine engine, string source) {
    var got = engine.evaluate (source);
    if (got.length != 1 || got[0].kind != Calcumon.LineKind.ANSWER || !("cm" in got[0].text)) {
        stderr.printf ("FAIL unit %s: kind=%s text=%s\n",
            source, kind_name (got.length > 0 ? got[0].kind : Calcumon.LineKind.EMPTY),
            got.length > 0 ? got[0].text : "");
        return 1;
    }
    return 0;
}

int expect_near (Calcumon.SheetEngine engine, string source, double expected) {
    var got = engine.evaluate (source);
    if (got.length != 1 || got[0].kind != Calcumon.LineKind.ANSWER) {
        stderr.printf ("FAIL near %s: kind=%s text=%s\n",
            source, kind_name (got.length > 0 ? got[0].kind : Calcumon.LineKind.EMPTY),
            got.length > 0 ? got[0].text : "");
        return 1;
    }
    double value = double.parse (got[0].text);
    double delta = value - expected;
    if (delta < 0) {
        delta = -delta;
    }
    if (delta > 0.001) {
        stderr.printf ("FAIL near %s: got %s expected ~%g\n", source, got[0].text, expected);
        return 1;
    }
    return 0;
}

int expect_sheet (Calcumon.SheetEngine engine, string source, Calcumon.LineResult[] expected) {
    var got = engine.evaluate (source);
    if (got.length != expected.length) {
        stderr.printf ("FAIL %s: expected %d lines, got %d\n", describe (source), expected.length, got.length);
        return 1;
    }
    for (int i = 0; i < expected.length; i++) {
        if (got[i].kind != expected[i].kind || got[i].text != expected[i].text || got[i].line != expected[i].line) {
            stderr.printf ("FAIL %s line %d: got %s %s, expected %s %s\n",
                describe (source), i + 1,
                kind_name (got[i].kind), got[i].text,
                kind_name (expected[i].kind), expected[i].text);
            return 1;
        }
    }
    return 0;
}

int expect_same_text (Calcumon.SheetEngine engine, string source) {
    var got = engine.evaluate (source);
    if (got.length < 2) {
        stderr.printf ("FAIL same text %s: got %d lines\n", describe (source), got.length);
        return 1;
    }
    for (int i = 0; i < got.length; i++) {
        if (got[i].kind != Calcumon.LineKind.ANSWER || got[i].text.length == 0) {
            stderr.printf ("FAIL same text %s line %d: %s %s\n",
                describe (source), i + 1, kind_name (got[i].kind), got[i].text);
            return 1;
        }
    }
    if (got[0].text != got[1].text) {
        stderr.printf ("FAIL same text %s: '%s' vs '%s'\n", describe (source), got[0].text, got[1].text);
        return 1;
    }
    return 0;
}

int expect_date_days (Calcumon.SheetEngine engine, string source, int line_a, int line_b, int days) {
    engine.evaluate (source);
    double a = engine.line_epoch_ms (line_a);
    double b = engine.line_epoch_ms (line_b);
    if (a != a || b != b) {
        stderr.printf ("FAIL date days %s: missing date on line %d or %d\n", describe (source), line_a, line_b);
        return 1;
    }
    double got = (b - a) / 86400000.0;
    double delta = got - days;
    if (delta < 0) {
        delta = -delta;
    }
    if (delta > 0.01) {
        stderr.printf ("FAIL date days %s: %g want %d\n", describe (source), got, days);
        return 1;
    }
    return 0;
}

int expect_date_ms (Calcumon.SheetEngine engine, string source, int line_a, int line_b, double expected_ms) {
    engine.evaluate (source);
    double a = engine.line_epoch_ms (line_a);
    double b = engine.line_epoch_ms (line_b);
    if (a != a || b != b) {
        stderr.printf ("FAIL date ms %s: missing date on line %d or %d\n", describe (source), line_a, line_b);
        return 1;
    }
    double delta = (b - a) - expected_ms;
    if (delta < 0) {
        delta = -delta;
    }
    if (delta > 1.0) {
        stderr.printf ("FAIL date ms %s: %g want %g\n", describe (source), b - a, expected_ms);
        return 1;
    }
    return 0;
}

string describe (string source) {
    return source.replace ("\n", "\\n");
}

string kind_name (Calcumon.LineKind kind) {
    switch (kind) {
    case Calcumon.LineKind.ANSWER:
        return "ANSWER";
    case Calcumon.LineKind.ERROR:
        return "ERROR";
    default:
        return "EMPTY";
    }
}
