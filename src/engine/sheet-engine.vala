private class Calcumon.TapeLine {
    public LineKind kind;
    public bool blank;
    public bool aggregate;
    public JSC.Value? value;

    public TapeLine (LineKind kind, bool blank, JSC.Value? value, bool aggregate = false) {
        this.kind = kind;
        this.blank = blank;
        this.value = value;
        this.aggregate = aggregate;
    }
}

public class Calcumon.SheetEngine : Object {
    private const string PRELUDE = """
function __formatValue(result, precision) {
  if (typeof result === 'number' && Number.isInteger(result)) {
    return math.format(result);
  }
  if (typeof result === 'number') {
    return math.format(result, {notation: 'fixed', precision: precision});
  }
  return math.format(result, {precision: precision});
}

function __evalLine(line, precision) {
  try {
    var result = parser.evaluate(line);
    if (result === undefined || typeof result === 'function') {
      return { kind: 'empty', text: '', value: undefined };
    }
    return { kind: 'answer', text: String(__formatValue(result, precision)), value: result };
  } catch (e) {
    var msg = (e && e.message) ? String(e.message) : String(e);
    return { kind: 'error', text: msg, value: undefined };
  }
}

function __isNumeric(v) {
  if (v === true || v === false || v === null || v === undefined) return false;
  if (typeof v === 'string') return false;
  if (typeof v === 'number') return isFinite(v);
  try {
    return !!(math.isNumeric(v) || math.isUnit(v));
  } catch (e) {
    return false;
  }
}

function __sumValues(arr) {
  if (!arr || arr.length === 0) {
    throw new Error('no numeric values');
  }
  var acc = arr[0];
  for (var i = 1; i < arr.length; i++) {
    acc = math.add(acc, arr[i]);
  }
  return acc;
}

function __avgValues(arr) {
  return math.divide(__sumValues(arr), arr.length);
}
""";

    private JsRuntime runtime;
    private GenericArray<TapeLine> tape;
    private JSC.Value? last_answer;
    public int precision { get; set; default = 4; }
    public bool continue_from_previous { get; set; default = true; }

    public SheetEngine () throws EngineError {
        runtime = new JsRuntime ();
        runtime.evaluate ("var parser = math.parser();");
        runtime.evaluate (PRELUDE);
        tape = new GenericArray<TapeLine> ();
    }

    public LineResult[] evaluate (string source) {
        tape = new GenericArray<TapeLine> ();
        last_answer = null;
        try {
            runtime.evaluate ("parser = math.parser();");
        } catch (EngineError e) {
            return { new LineResult (1, LineKind.ERROR, e.message) };
        }

        var raw_lines = split_lines (source);
        var results = new LineResult[raw_lines.length];
        for (int i = 0; i < raw_lines.length; i++) {
            results[i] = eval_line (i + 1, raw_lines[i]);
        }
        return results;
    }

    private LineResult eval_line (int number, string raw) {
        var expr = strip_comment (raw).strip ();
        bool blank = raw.strip ().length == 0;
        if (expr.length == 0) {
            var empty = new LineResult (number, LineKind.EMPTY, "");
            tape.add (new TapeLine (LineKind.EMPTY, blank, null));
            return empty;
        }

        if (is_reserved_assignment (expr)) {
            return fail (number, "reserved keyword");
        }

        if (has_identifier (expr, "line0")) {
            return fail (number, "line0 is invalid");
        }

        if (has_identifier (expr, "ans") && last_answer == null) {
            return fail (number, "no previous answer");
        }

        try {
            if (continue_from_previous && last_answer != null && is_continue_line (expr)) {
                runtime.context.set_value ("__bindVal", last_answer);
                runtime.evaluate ("parser.set('__prev', __bindVal);");
                expr = "__prev " + expr;
            }

            if (has_bare_keyword (expr, "total") || has_bare_keyword (expr, "avg")) {
                var parts = numeric_from (0);
                if (parts.length == 0) {
                    return fail (number, "no numeric values");
                }
                var arr = js_array (parts);
                if (has_bare_keyword (expr, "total")) {
                    runtime.context.set_value ("__bindVal", runtime.call ("__sumValues", { arr }));
                    runtime.evaluate ("parser.set('__kw_total', __bindVal);");
                }
                if (has_bare_keyword (expr, "avg")) {
                    runtime.context.set_value ("__bindVal", runtime.call ("__avgValues", { arr }));
                    runtime.evaluate ("parser.set('__kw_avg', __bindVal);");
                }
            }

            if (has_bare_keyword (expr, "subtotal")) {
                int start = 0;
                for (int i = 0; i < tape.length; i++) {
                    if (tape[i].blank) {
                        start = i + 1;
                    }
                }
                var parts = numeric_from (start);
                if (parts.length == 0) {
                    return fail (number, "no numeric values");
                }
                runtime.context.set_value ("__bindVal", runtime.call ("__sumValues", { js_array (parts) }));
                runtime.evaluate ("parser.set('__kw_subtotal', __bindVal);");
            }

            bool aggregate = has_bare_keyword (expr, "total")
                || has_bare_keyword (expr, "subtotal")
                || has_bare_keyword (expr, "avg");
            expr = replace_keyword (expr, "subtotal", "__kw_subtotal");
            expr = replace_keyword (expr, "total", "__kw_total");
            expr = replace_keyword (expr, "avg", "__kw_avg");

            var ctx = runtime.context;
            var obj = runtime.call ("__evalLine", {
                new JSC.Value.string (ctx, expr),
                new JSC.Value.number (ctx, precision)
            });
            var kind_s = obj.object_get_property ("kind").to_string ();
            var text = obj.object_get_property ("text").to_string ().strip ();
            switch (kind_s) {
            case "answer":
                var value = obj.object_get_property ("value");
                bind_answer (number, value);
                tape.add (new TapeLine (LineKind.ANSWER, false, value, aggregate));
                last_answer = value;
                return new LineResult (number, LineKind.ANSWER, text);
            case "empty":
                tape.add (new TapeLine (LineKind.EMPTY, false, null));
                return new LineResult (number, LineKind.EMPTY, "");
            default:
                tape.add (new TapeLine (LineKind.ERROR, false, null));
                return new LineResult (number, LineKind.ERROR, text);
            }
        } catch (EngineError e) {
            return fail (number, e.message);
        }
    }

    private LineResult fail (int number, string text) {
        tape.add (new TapeLine (LineKind.ERROR, false, null));
        return new LineResult (number, LineKind.ERROR, text);
    }

    private void bind_answer (int number, JSC.Value value) throws EngineError {
        runtime.context.set_value ("__bindVal", value);
        runtime.evaluate ("parser.set('ans', __bindVal);");
        runtime.evaluate ("parser.set('line%d', __bindVal);".printf (number));
    }

    private JSC.Value js_array (GenericArray<JSC.Value> parts) {
        return new JSC.Value.array_from_garray (runtime.context, parts);
    }

    private GenericArray<JSC.Value> numeric_from (int start) {
        var parts = new GenericArray<JSC.Value> ();
        for (int i = start; i < tape.length; i++) {
            var value = tape[i].value;
            if (tape[i].kind != LineKind.ANSWER || value == null || tape[i].aggregate) {
                continue;
            }
            try {
                runtime.context.set_value ("__v", value);
                if (runtime.evaluate ("__isNumeric(__v)").to_boolean ()) {
                    parts.add (value);
                }
            } catch (EngineError e) {
                continue;
            }
        }
        return parts;
    }

    private static bool is_continue_line (string expr) {
        if (expr.length == 0) {
            return false;
        }
        char c = (char) expr.data[0];
        return c == '+' || c == '-' || c == '*' || c == '/';
    }

    private static bool is_reserved_assignment (string expr) {
        int eq = expr.index_of ("=");
        if (eq <= 0) {
            return false;
        }
        if (eq + 1 < expr.length && expr.data[eq + 1] == '=') {
            return false;
        }
        uint8 before = expr.data[eq - 1];
        if (before == '!' || before == '<' || before == '>' || before == '=') {
            return false;
        }
        return is_reserved_name (expr.substring (0, eq).strip ());
    }

    private static bool is_reserved_name (string name) {
        return name == "ans" || name == "total" || name == "subtotal" || name == "avg" || is_line_name (name);
    }

    private static bool is_line_name (string name) {
        if (!name.has_prefix ("line") || name.length < 5) {
            return false;
        }
        for (int i = 4; i < name.length; i++) {
            uint8 c = name.data[i];
            if (c < '0' || c > '9') {
                return false;
            }
        }
        return true;
    }

    private static bool has_bare_keyword (string expr, string name) {
        int i = 0;
        while (i < expr.length) {
            if (is_ident_start (expr.data[i])) {
                int j = i + 1;
                while (j < expr.length && is_ident_char (expr.data[j])) {
                    j++;
                }
                int k = j;
                while (k < expr.length && ((char) expr.data[k]).isspace ()) {
                    k++;
                }
                bool call = k < expr.length && expr.data[k] == '(';
                if (!call && expr.substring (i, j - i) == name) {
                    return true;
                }
                i = j;
            } else {
                i++;
            }
        }
        return false;
    }

    private static string replace_keyword (string expr, string name, string replacement) {
        var builder = new StringBuilder ();
        int i = 0;
        while (i < expr.length) {
            if (is_ident_start (expr.data[i])) {
                int j = i + 1;
                while (j < expr.length && is_ident_char (expr.data[j])) {
                    j++;
                }
                int k = j;
                while (k < expr.length && ((char) expr.data[k]).isspace ()) {
                    k++;
                }
                bool call = k < expr.length && expr.data[k] == '(';
                string ident = expr.substring (i, j - i);
                if (!call && ident == name) {
                    builder.append (replacement);
                } else {
                    builder.append (ident);
                }
                i = j;
            } else {
                builder.append_c ((char) expr.data[i]);
                i++;
            }
        }
        return builder.str;
    }

    private static bool has_identifier (string expr, string name) {
        int i = 0;
        while (i < expr.length) {
            if (is_ident_start (expr.data[i])) {
                int j = i + 1;
                while (j < expr.length && is_ident_char (expr.data[j])) {
                    j++;
                }
                if (expr.substring (i, j - i) == name) {
                    return true;
                }
                i = j;
            } else {
                i++;
            }
        }
        return false;
    }

    private static bool is_ident_start (uint8 c) {
        return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '_';
    }

    private static bool is_ident_char (uint8 c) {
        return is_ident_start (c) || (c >= '0' && c <= '9');
    }

    private static string strip_comment (string line) {
        int slash = line.index_of ("//");
        int hash = line.index_of ("#");
        int cut = -1;
        if (slash >= 0 && hash >= 0) {
            cut = int.min (slash, hash);
        } else if (slash >= 0) {
            cut = slash;
        } else if (hash >= 0) {
            cut = hash;
        }
        if (cut < 0) {
            return line;
        }
        return line.substring (0, cut);
    }

    private static string[] split_lines (string source) {
        if (source.length == 0) {
            return { "" };
        }
        return source.split ("\n");
    }
}
