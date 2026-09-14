# Phase 08. Dates, percentages, and answers

Phases 01–07 shipped a notepad that can evaluate a page. This phase adds the remaining sheet words people type, then makes the results column usable: short errors, click to copy.

No new JS libraries. Dates use `Date` and `Intl` inside the existing prelude. Percentages are a line rewrite. The engine still returns one `LineResult` per line.

## Goal

`today`, `now`, and duration arithmetic work on a sheet. `10% of 20` and `40 + 5%` mean what a person means. An error line shows `Error`, not a math.js stack fragment. Clicking an answer copies it.

## Done when

```
today                 → a local date
now                   → a local date and time
today + 3 weeks       → that date plus 21 days
now + 36 hours        → that timestamp plus 36 hours
today - 1 day         → yesterday
tmrw = today + 1 day
tmrw                  → tomorrow's date
```

```
10% of 20             → 2
40 + 5%               → 42
8 % 3                 → 2   (still modulus)
100%                  → 1
```

```
1 +                   → results column shows Error
```

Click the `2` on `10% of 20`. Clipboard holds `2`. Click `Error`. Clipboard holds the real message.

`today` and `now` are reserved, same as `ans`. `today = 5` is an error.

## Layout and API

```
src/
  engine/sheet-engine.vala   # date keywords, % of rewrite, date + duration
  sheet-view.vala            # Error label, tooltip, click-to-copy, optional gutter
  window.vala                # ToastOverlay if a copy toast is worth it
tests/
  engine-test.vala
  sheet-smoke.vala
```

Keep rewriting in the engine. The UI does not parse dates or percents.

**Dates.** At the start of each `evaluate()`, bind `today` and `now` in the parser. `today` is local calendar date (midnight). `now` is local date and time. Format with `Intl.DateTimeFormat` using the system locale. No date-format setting. No weekday prefix.

math.js will not add a unit to a `Date`. After the usual evaluate fails, or before it if the line matches, handle:

- `today|now` `+` or `-` a time duration
- a parser value that is already a date, same operators
- assignment of that result (`tmrw = today + 1 day`)

Duration units: the math.js time set, at least `millisecond`, `second`, `minute`, `hour`, `day`, `week`, `month`, `year` (and the obvious plurals). Convert the duration with math.js (`… to hours`) and add it to the date. Same trick Numara uses, without Luxon.

Store dates in scope as dates, not as pretty strings, so `tmrw + 2 days` still works. `__formatValue` prints them. A date is not numeric for `total` / `avg`.

Slash dates such as `7/31/2023 + 4 days` are locale-shaped and easy to get wrong. Take ISO `2023-07-31 + 4 days` if it is cheap. If locale slash parsing needs a date library, skip it this phase. Do not stall `today + 3 weeks` on it.

**Percentages.** After comment strip, rewrite `% of` / `%of` (flexible spaces) to `/100*`. `10% of 20` becomes `10/100*20`.

Then try math.js. Current math.js already treats postfix `%` as percent (`40 + 5%` is 42, `100%` is 1) and infix `%` as modulus (`8 % 3` is 2). Prove that with tests. If the vendored bundle does not, add a postfix rewrite. Do not turn `8 % 3` into a percent.

**Errors.** `LineResult.text` stays the full message. Engine tests do not change shape.

`SheetView` keeps the last `LineResult[]`. For `ERROR` rows, write `Error` into the results buffer and keep the existing error color. Tooltip on that row is `text`. GtkSource marks on the matching editor line are worth doing if the gutter stays aligned. If marks fight line pairing, skip the gutter and leave the red `Error` as the signal.

**Copy.** `results_view` is still not an editor. A `Gtk.GestureClick` maps y to a line. `ANSWER` copies `text`. `ERROR` copies the engine message. `EMPTY` does nothing. Do not steal `Ctrl+C` in the source view.

A short `Adw.Toast` ("Copied") is fine. Wrap the window content in `Adw.ToastOverlay` if you add one. No notification settings.

## Steps

1. Reserve `today` and `now`. Bind them at the start of `evaluate()`. Print `today` and `now` alone.
2. Date plus or minus a duration. Assignments that store a date. `__formatValue` and `total` skip dates.
3. `% of` rewrite. Tests for percent, percent-of, and modulus.
4. `SheetView`: display `Error`, tooltip with detail, click-to-copy. Gutter marks only if they stay cheap.
5. Toast overlay only if copy has no other feedback. Tooltip-on-hover is enough if a toast means touching `Window` for no gain.
6. README keywords list: add `today`, `now`, and the two percent forms. Update `tests/sheet-smoke.vala` so `1 +` expects `Error`.

## Tests

Engine, besides the sheets in "Done when":

- `today + 1 day - 1 day` formats the same as `today` on that run.
- `today + 7 days` is seven calendar days after `today`, not 7 hours.
- `now + 1 hour` is about 3600 seconds after `now` on that run. Do not hard-code a clock reading.
- `today = 1` and `now = 1` are ERROR.
- A comment must not reset a date. A blank line does not affect dates.
- `10\n20\ntotal` is still 30. A `today` line in the tape is skipped by `total`.
- `10% of (5+5)` is 1.
- `8 % 3` is 2.
- `1 +` is still ERROR with a non-empty `text`.

Manual:

- Type `today + 3 weeks`. Change nothing, wait a second, type again. The date is still today-based, not cached from process start in a stale way. Binding on each `evaluate()` is the fix.
- Click an answer. Paste into the editor. Same digits.
- `1 +` shows `Error`. Hover shows the math.js message. Next line still evaluates.
- Dark and light: `Error` stays destructive red.

## Out of scope

Luxon, weekday-on-date, a date format picker, locale slash dates if they need a library, live currency rates, `$` / `€` as units, plots, Formula.js, nerdamer, custom functions UI, answer-below, wrap, thousand separators, copy-with-separator.
