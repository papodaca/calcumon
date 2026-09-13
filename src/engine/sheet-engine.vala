public class Calcumon.SheetEngine : Object {
    private const string PRELUDE = """
function __evalLine(line, precision) {
  try {
    var result = parser.evaluate(line);
    if (result === undefined || typeof result === 'function') {
      return { kind: 'empty', text: '' };
    }
    var text;
    if (typeof result === 'number' && Number.isInteger(result)) {
      text = math.format(result);
    } else if (typeof result === 'number') {
      text = math.format(result, {notation: 'fixed', precision: precision});
    } else {
      text = math.format(result, {precision: precision});
    }
    return { kind: 'answer', text: String(text) };
  } catch (e) {
    var msg = (e && e.message) ? String(e.message) : String(e);
    return { kind: 'error', text: msg };
  }
}
""";

    private JsRuntime runtime;
    public int precision { get; set; default = 4; }

    public SheetEngine () throws EngineError {
        runtime = new JsRuntime ();
        runtime.evaluate ("var parser = math.parser();");
        runtime.evaluate (PRELUDE);
    }

    public LineResult[] evaluate (string source) {
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
        if (expr.length == 0) {
            return new LineResult (number, LineKind.EMPTY, "");
        }

        try {
            var ctx = runtime.context;
            var obj = runtime.call ("__evalLine", {
                new JSC.Value.string (ctx, expr),
                new JSC.Value.number (ctx, precision)
            });
            var kind_s = obj.object_get_property ("kind").to_string ();
            var text = obj.object_get_property ("text").to_string ().strip ();
            switch (kind_s) {
            case "answer":
                return new LineResult (number, LineKind.ANSWER, text);
            case "empty":
                return new LineResult (number, LineKind.EMPTY, "");
            default:
                return new LineResult (number, LineKind.ERROR, text);
            }
        } catch (EngineError e) {
            return new LineResult (number, LineKind.ERROR, e.message);
        }
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
