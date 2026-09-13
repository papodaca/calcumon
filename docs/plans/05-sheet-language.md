# Phase 05. Sheet language

math.js already knows `sin` and `cm`. This phase adds the words people type on a notepad: previous answer, this line, running total.

## Goal

Implement Numara's useful keywords on top of `SheetEngine`, plus optional continue-from-previous-line. Units and functions stay math.js. Do not reimplement trigonometry.

## Done when

These sheets evaluate as described.

```
10
20
ans          → 20
line1        → 10
total        → 50
```

```
10
20

30
subtotal     → 30
total        → 60
```

```
10
20
avg          → 15
```

A line that starts with `+`, `-`, `*`, or `/` continues from the previous answer when that setting is on. Default on.

```
100
+ 20         → 120
* 2          → 240
```

`5 cm + 2 in` still works from phase 02. `lineN` with a missing or empty source line is an error or empty, not a crash. `line0` is invalid.

## Layout and API

Keep the work inside `SheetEngine`. The UI should not parse keywords.

Before `parser.evaluate(line)`, rewrite or bind:

**`ans`.** After each successful `ANSWER`, store that JS value as `ans` in the parser (`parser.set('ans', value)`). A line that is exactly `ans` or contains `ans` as an identifier then sees the previous answer. If there is no previous answer, `ans` errors or evaluates empty. Prefer error on a lone `ans` at the top of the page.

**`lineN`.** `N` is a 1-based line number. Bind `line1`, `line2`, ... after each line, or parse the identifier and substitute the stored result. Binding after each answer is simpler: after finishing line 4, `parser.set('line4', value)`. Forward references (`line10` on line 2) fail. That is acceptable.

Only bind lines that produced `ANSWER`. Do not bind `line3` if line 3 was a comment.

**`total`.** Sum of numeric answers from line 1 through the previous line, plus the current line if you want Numara's "up to this keyword" behavior. Treat `total` as a keyword that consumes prior numeric answers **not including** the `total` line itself. `10` / `20` / `total` is 30. If `total` included itself you would double-count.

What is numeric: math.js numbers and unit values that `add` can sum. Skip errors, empties, booleans, and text. If units mix in a way math.js cannot add, the `total` line is `ERROR`.

**`subtotal`.** Same as `total` but the window starts after the most recent blank line. A comment line does not start a new block. Only a fully empty line does.

**`avg`.** Arithmetic mean of the same set `total` uses. Count is the number of numeric answers in that set, not the number of source lines.

**Continue-from-previous.** If the trimmed line matches `^[+\-*/]` and the previous answer exists, prepend that answer as a parenthesized value, then evaluate. `100` then `+ 20` becomes `(100) + 20`. Turn this off with a boolean on `SheetEngine` (GSettings in 06). Default `true`.

Keyword detection must not fire inside comments you already stripped. `ans` as part of a longer identifier (`answer`) is not `ans`. Match identifiers, not substrings.

Implementation choice: do rewriting in Vala, or inject a small JS prelude that defines getters. Vala rewriting is easier to test. If you inject JS functions named `total` they may collide with user variables. Prefer reserved keywords that you strip/replace before evaluate, and do not `parser.set('total', ...)`.

## Dates

Numara has `today` and `now` and `today + 3 weeks`. math.js has limited date support. If a few lines of JS bind `today`/`now` as math.js values and `+ 3 weeks` works, take it. If it needs a date library, skip dates this phase. Do not stall the keywords above on calendar math.

## Steps

1. Add a result tape to `SheetEngine`: per-line stored JS values plus a "blank line here" flag.
2. Implement `ans` and `lineN` first. They are local lookups.
3. Implement `total`, `subtotal`, `avg` using that tape.
4. Implement continue-from-previous as a line rewrite.
5. Extend `tests/engine-test.vala` with the fixtures in "Done when".
6. Try `today`. Keep or drop it based on an hour of work, not a week.

## Tests

Besides the sheets above:

- Comment line between numbers does not reset `subtotal`. A blank line does.
- `line4` before line 4 has been answered is ERROR.
- Continue-from-previous off: a line `+ 20` is ERROR or math.js's own error, not 120.
- Mixing `10` and `5 cm` in `total` errors if math.js cannot add them.
- User variable `ans` should not be assignable in a way that breaks the keyword. If `ans = 5` fights the binding, make `ans` reserved and error on assignment.

## Out of scope

Plots, user-defined JS functions from Numara's settings panel, custom units UI, Formula.js, nerdamer, currency rates, `lineN` with relative indices (`line-1`).
