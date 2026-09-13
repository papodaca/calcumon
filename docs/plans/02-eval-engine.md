# Phase 02. Eval engine

Math happens here, with no GTK in the way. If a line cannot be evaluated, this layer says so. The UI in 03 only displays what this returns.

## Goal

A Vala sheet evaluator that loads math.js into JavaScriptCore, walks a page of text, and returns one result per line. Assignments persist for later lines. Comments and blank lines produce no answer.

## Done when

- math.js is vendored in the tree and Meson ships it with the binary or as a GResource.
- `SheetEngine.evaluate(string source)` returns an array of `LineResult`, one entry per input line including blanks.
- `a = 2` then `a * 3` yields 6 on the second line.
- `1 + 2 // note` yields 3. A line that is only `//` or `#` plus text yields empty.
- `5 cm + 2 in` evaluates using math.js units.
- Broken math yields `kind = ERROR` and a short message, not a thrown Vala exception.
- A small headless test binary or Meson test target covers the cases above. No window required.

## Layout and API

```
src/
  engine/
    js-runtime.vala      # owns JSC.Context, loads math.js once
    sheet-engine.vala    # per-page parser + line walk
    line-result.vala     # LineKind + LineResult
vendor/
  math.min.js            # or the official browser bundle; pin the version in a comment
```

Add `javascriptcoregtk-6.0` (or the version CachyOS ships that matches WebKitGTK 6) to Meson. If the 6.0 pkg-config name differs on this box, record the actual `dependency()` name in `meson.build`.

**`LineKind`:** `ANSWER`, `EMPTY`, `ERROR`.

**`LineResult`:** `int line` (1-based), `LineKind kind`, `string text`. `text` is the printed answer or the error string. Empty for `EMPTY`.

**`JsRuntime`.** Create one `JSC.Context`. Evaluate the vendored math.js source. Expose a helper that runs a JS string and returns a `JSC.Value`. Load math.js once per process if the context can be cloned cheaply; otherwise one context per `SheetEngine` is fine for now. Pages in 04 will each need an isolated parser. Isolation matters more than sharing one global math.js heap.

**`SheetEngine`.** On construct, create a math.js parser in JS, e.g. `this.parser = math.parser()`. `evaluate(source)`:

1. Split `source` on `\n`. Keep the last empty line if the buffer ends with a newline, so line counts match the editor.
2. For each line, strip a trailing `//` or `#` comment. If `#` appears as part of a token we care about later, revisit this. Numara treats `#` as comment. Do the same.
3. Trim. If the remainder is empty, emit `EMPTY`.
4. Call `parser.evaluate(line)` through JSC.
5. If JS throws, emit `ERROR` with `e.message` or equivalent, trimmed.
6. If the JS result is `undefined` or a function definition with no printable value, emit `EMPTY` or a reasonable print. Prefer matching math.js `format()` for numbers, units, and matrices.
7. Assignments stay in `parser`. Do not reset scope between lines. `evaluate()` of a full source **does** reset the parser first, then replays every line. That way editing line 1 updates line 10. Never incrementally patch scope in this phase. Full replay is simpler and matches "the page is the program."

Print numbers with math.js `format` using a fixed precision for now, 4 decimal digits unless the value is an integer. Phase 06 can expose precision. Do not invent a second formatter in Vala.

Comment-only and blank lines are notes. A non-comment line that math.js rejects is an error, not a silent note. Users who want prose use `//` or `#`. Guessing "this looks like English" is a later problem if it is a problem at all.

## Steps

1. Confirm `javascriptcoregtk` Vala bindings on this system. A 10-line program that `evaluate("1+1")` is enough.
2. Vendor math.js. Prefer a single-file build that attaches `math` on the global object inside JSC. If the ESM build will not load, use the UMD/browser bundle. Note the version next to the file.
3. GResource the JS file so the installed app does not depend on a source-tree path.
4. Implement `JsRuntime` and prove `math.evaluate('1+2')` returns 3 from Vala.
5. Implement `SheetEngine` as specified.
6. Add `tests/engine-test.vala` or a `meson test` executable that feeds fixtures and checks `LineResult` arrays.

## Tests

Minimum fixtures:

| Input | Expected |
| --- | --- |
| `1 + 2` | ANSWER `3` |
| `a = 2\na * 3` | `2`, then `6` |
| `1 + 2 // add` | `3` |
| `# heading` | EMPTY |
| empty line between two sums | EMPTY on the middle result |
| `5 cm + 2 in` | a length, in math.js's default unit formatting |
| `1 +` | ERROR, no crash |
| `sin(pi/2)` | ANSWER near `1` |

Replay: after `a = 2` then `a * 3`, a second `evaluate()` with `a = 5` then `a * 3` must show 15, not 6. Scope must reset at the start of each full evaluate.

## Out of scope

GTK. Tabs. `ans` / `total` / `lineN`. Continue-from-previous-line. GSettings. Date keywords. Currency rates. Do not wrap Formula.js or nerdamer.

## Fallback

If JSC will not load math.js (module loader, missing `globalThis`, etc.), stop and switch the engine host to GJS, or evaluate math.js through a tiny GJS helper process. Do not start a second math library. The `SheetEngine` API above stays.
