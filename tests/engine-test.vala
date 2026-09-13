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
