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
var parser;
var __lastAnswer;

function __todayMs() {
  var n = new Date();
  return new Date(n.getFullYear(), n.getMonth(), n.getDate()).getTime();
}

function __wrapDate(ms, withTime) {
  return { __calDate: true, ms: ms, withTime: !!withTime };
}

function __isDate(v) {
  return !!(v && typeof v === 'object' && v.__calDate === true && typeof v.ms === 'number');
}

function __hasClock(ms) {
  var d = new Date(ms);
  return d.getHours() !== 0 || d.getMinutes() !== 0 || d.getSeconds() !== 0 || d.getMilliseconds() !== 0;
}

function __formatDate(ms, withTime) {
  var d = new Date(ms);
  var showTime = withTime || __hasClock(ms);
  if (showTime) {
    return new Intl.DateTimeFormat(undefined, {
      year: 'numeric', month: 'numeric', day: 'numeric',
      hour: 'numeric', minute: 'numeric', second: 'numeric'
    }).format(d);
  }
  return new Intl.DateTimeFormat(undefined, {
    year: 'numeric', month: 'numeric', day: 'numeric'
  }).format(d);
}

function __formatValue(result, precision) {
  if (__isDate(result)) {
    return __formatDate(result.ms, result.withTime);
  }
  if (typeof result === 'number' && Number.isInteger(result)) {
    return math.format(result);
  }
  if (typeof result === 'number') {
    return math.format(result, {notation: 'fixed', precision: precision});
  }
  return math.format(result, {precision: precision});
}

function __rewritePercentOf(line) {
  return line.replace(/%[ \t]*of[ \t]*/gi, '/100*');
}

function __isoDate(str) {
  var m = /^(\d{4})-(\d{2})-(\d{2})$/.exec(str);
  if (!m) return null;
  var y = parseInt(m[1], 10);
  var mo = parseInt(m[2], 10);
  var d = parseInt(m[3], 10);
  var dt = new Date(y, mo - 1, d);
  if (dt.getFullYear() !== y || dt.getMonth() !== mo - 1 || dt.getDate() !== d) return null;
  return __wrapDate(dt.getTime(), false);
}

function __rhsAssignment(line) {
  var eq = line.indexOf('=');
  if (eq <= 0) return null;
  var next = eq + 1 < line.length ? line.charAt(eq + 1) : '';
  var prev = line.charAt(eq - 1);
  if (next === '=' || prev === '!' || prev === '<' || prev === '>' || prev === '=') return null;
  var name = line.substring(0, eq).trim();
  if (!/^[A-Za-z_][A-Za-z0-9_]*$/.test(name)) return null;
  return { name: name, expr: line.substring(eq + 1).trim() };
}

function __exprOf(line) {
  var a = __rhsAssignment(line);
  return a ? a.expr : line;
}

function __isIsoDateStart(line) {
  return /^\d{4}-\d{2}-\d{2}(\b|$)/.test(__exprOf(line).trim());
}

function __resolveDate(datePart) {
  datePart = datePart.trim();
  if (!datePart) return null;
  var iso = __isoDate(datePart);
  if (iso) return iso;
  try {
    var v = parser.evaluate(datePart);
    if (__isDate(v)) return v;
  } catch (e) {}
  return null;
}

function __hoursFrom(expr) {
  var u = math.evaluate('(' + expr + ') to hours');
  if (u && typeof u.toNumber === 'function') {
    try { return u.toNumber('hours'); } catch (e) {}
  }
  return Number(math.number(u));
}

function __tryDate(line) {
  var assign = __rhsAssignment(line);
  var expr = assign ? assign.expr : line;
  var durRe = /([+-])\s*(\d+(?:\.\d+)?)\s*(milliseconds?|seconds?|minutes?|hours?|days?|weeks?|months?|years?)\b/gi;
  var hoursExpr = '';
  var foundDur = false;
  var datePart = expr.replace(durRe, function(m, sign, num, unit) {
    foundDur = true;
    hoursExpr += ' ' + sign + ' (' + num + ' ' + unit + ')';
    return '';
  }).trim();
  var base = __resolveDate(datePart);
  if (!base) return null;
  if (!foundDur && !assign && !__isoDate(datePart)) return null;
  var result = base;
  if (foundDur) {
    var hours = __hoursFrom(hoursExpr);
    if (!isFinite(hours)) return null;
    result = __wrapDate(base.ms + hours * 3600 * 1000, base.withTime);
  }
  if (assign) parser.set(assign.name, result);
  return result;
}

function __commit(result, number) {
  __lastAnswer = result;
  parser.set('ans', result);
  parser.set('line' + number, result);
}

function __evalLine(line, precision, number) {
  try {
    line = __rewritePercentOf(line);
    var result;
    if (__isIsoDateStart(line)) {
      result = __tryDate(line);
      if (result == null) throw new Error('Invalid Date');
    } else {
      try {
        result = parser.evaluate(line);
      } catch (e) {
        result = __tryDate(line);
        if (result == null) {
          var assign = __rhsAssignment(line);
          result = __resolveDate(assign ? assign.expr : line);
          if (result != null && assign) parser.set(assign.name, result);
        }
        if (result == null) throw e;
      }
    }
    if (result === undefined || typeof result === 'function') {
      return { kind: 'empty', text: '', value: undefined };
    }
    __commit(result, number);
    return { kind: 'answer', text: String(__formatValue(result, precision)), value: result };
  } catch (e) {
    var msg = (e && e.message) ? String(e.message) : String(e);
    return { kind: 'error', text: msg, value: undefined };
  }
}

function __isNumeric(v) {
  if (__isDate(v)) return false;
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

function __lineMs(n) {
  try {
    var v = parser.get('line' + n);
    return __isDate(v) ? v.ms : NaN;
  } catch (e) {
    return NaN;
  }
}

function __resetParser() {
  parser = math.parser();
  __lastAnswer = undefined;
  parser.set('today', __wrapDate(__todayMs(), false));
  parser.set('now', __wrapDate(Date.now(), true));
}
""";

    private JsRuntime runtime;
    private GenericArray<TapeLine> tape;
    private bool has_last_answer;
    public int precision { get; set; default = 4; }
    public bool continue_from_previous { get; set; default = true; }

    public SheetEngine () throws EngineError {
        runtime = new JsRuntime ();
        runtime.evaluate (PRELUDE);
        runtime.evaluate ("__resetParser();");
        tape = new GenericArray<TapeLine> ();
    }

    public LineResult[] evaluate (string source) {
        tape = new GenericArray<TapeLine> ();
        has_last_answer = false;
        try {
            runtime.evaluate ("__resetParser();");
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

        if (has_identifier (expr, "ans") && !has_last_answer) {
            return fail (number, "no previous answer");
        }

        try {
            if (continue_from_previous && has_last_answer && is_continue_line (expr)) {
                runtime.evaluate ("parser.set('__prev', __lastAnswer);");
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
                new JSC.Value.number (ctx, precision),
                new JSC.Value.number (ctx, number)
            });
            var kind_s = obj.object_get_property ("kind").to_string ();
            var text = obj.object_get_property ("text").to_string ().strip ();
            switch (kind_s) {
            case "answer":
                var value = obj.object_get_property ("value");
                tape.add (new TapeLine (LineKind.ANSWER, false, value, aggregate));
                has_last_answer = true;
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

    public double line_epoch_ms (int number) {
        try {
            return runtime.evaluate ("__lineMs(%d)".printf (number)).to_double ();
        } catch (EngineError e) {
            return double.NAN;
        }
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
        return name == "ans" || name == "total" || name == "subtotal" || name == "avg"
            || name == "today" || name == "now" || is_line_name (name);
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
