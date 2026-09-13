# Phase 03. Notepad UI

This is the product. A sheet you type into, answers on the right, no equals key.

## Goal

Replace the lone GtkSourceView from 01 with a two-column sheet. Left column is the editor. Right column is answers from `SheetEngine`. Results update shortly after you stop typing. Scroll and line height stay aligned.

## Done when

- Typing `1+2` on line 1 shows `3` on the same row in the results column without pressing Return or a button.
- Adding a second line `3*4` shows `12` on row 2. Changing line 1 recomputes line 2 if it depends on a variable.
- Blank and comment lines show no answer.
- An error shows on that row as text, not a dialog. Focus stays in the editor.
- Vertical scroll of the editor moves the results by the same amount. Line 40 in the gutter sits next to line 40's answer.
- Wrapped input is allowed only if both columns still agree on row identity. If wrapping breaks alignment, keep wrap off this phase and leave it to 06.

## Layout and API

```
src/
  sheet-view.vala     # Gtk.Box or Gtk.Grid: editor | results
  window.vala         # hosts one SheetView (tabs come in 04)
```

**`SheetView`** is a `Gtk.Widget` subclass. It owns:

- `GtkSource.View` + `GtkSource.Buffer` on the left, inside `Gtk.ScrolledWindow`
- A read-only `Gtk.TextView` on the right, same font, same line spacing, inside its own `Gtk.ScrolledWindow`
- One `SheetEngine`
- A debounce source id (`GLib.Timeout`)

Bind the two scrolled windows to the **same** vertical `Gtk.Adjustment`. Horizontal scroll stays independent. Results never wrap. One answer per buffer line.

Copy font description, `pixels-above-lines`, `pixels-below-lines`, and line-number gutter width into the results view so baselines match. If the gutter makes the first text column sit lower than the results, pad the results view or hide numbers until 06. Alignment bugs here are the whole feature. Fix them before adding chrome.

On `Gtk.TextBuffer.changed`, cancel any pending timeout, schedule `recompute()` in about 50ms. `recompute()` reads `buffer.text`, calls `engine.evaluate()`, and writes one output line per `LineResult`. Pad with empty lines so the results buffer has the same line count as the source.

Do not run evaluate on the GTK thread if a large sheet stalls typing. Phase 02 is sync and probably fine for hundreds of lines. If the UI hitch is obvious, move `evaluate()` off-thread in this phase with a generation counter so stale results cannot overwrite a newer buffer. Do not start that work until you feel the hitch.

`Window` puts `SheetView` where the bare source view was. Header bar unchanged.

Answer column width: a modest request, around 12 to 16 characters, expanding if the window is wide. A `Gtk.Separator` between the panes is enough. Skip a full `Gtk.Paned` unless the separator feels cramped.

## Steps

1. Add `SheetView`. Move the source view out of `window.vala`.
2. Construct `SheetEngine` inside `SheetView`. Handle engine init failure with an `Adw.StatusPage` or a banner, not a silent empty window. math.js load errors should be loud once.
3. Wire debounce + `recompute()`.
4. Match fonts and line metrics. Sit with a 30-line sheet and a ruler if you have to.
5. Style answers as secondary/dimmed relative to input, still readable. Errors use the destructive/error color from the Adwaita palette.
6. Keep the caret in the editor after each recompute. Do not steal focus.

## Tests

Manual, on a real window:

- `1+2` then wait. Answer `3`.
- `a = 5` / `a^2`. Change `5` to `6`. Right column becomes `36`.
- Ten blank lines, then a sum. Scroll from top to bottom. Rows stay paired.
- `1 +` shows an error on that line. Next line still evaluates.
- Paste 200 lines of `1+1`. Typing at the bottom still feels live. If not, do the generation-counter thread mentioned above.

No screenshot-based tests required.

## Out of scope

Tabs, persistence, `ans`/`total`/`lineN`, settings, answer-below-the-expression layout, syntax highlighting themes beyond GtkSourceView defaults, print.
