# Phase 01. App skeleton

Get a window on screen. If this phase is flaky, every later phase sits on sand.

## Goal

A Meson Vala project that opens an Adwaita window with a header bar and a GtkSourceView. You can type in the view. Nothing evaluates.

## Done when

- `meson setup build && meson compile -C build` succeeds on CachyOS.
- `./build/src/calcumon` or the Meson-installed binary opens one window.
- The window uses libadwaita styling and follows the system light/dark preference.
- The editor is a `GtkSource.View` inside a `Gtk.ScrolledWindow`. Caret, selection, and wrapping work as a normal text view.
- Closing the window quits the application.

## Layout and API

```
calcumon/
  meson.build
  src/
    meson.build
    main.vala
    application.vala
    window.vala
  data/
    dev.calcumon.Calcumon.desktop.in
    icons/   # optional this phase; a stock or simple icon is enough
```

**`Calcumon.Application`** extends `Adw.Application`. Application id `dev.calcumon.Calcumon`. On `activate`, present a single `Calcumon.Window`.

**`Calcumon.Window`** extends `Adw.ApplicationWindow`. Use `Adw.ToolbarView` with an `Adw.HeaderBar`. Title "Calcumon". Content is a `GtkSource.View` in a `Gtk.ScrolledWindow`. Monospace font. Show line numbers now; 06 will make that a setting, but GtkSourceView is easier to wire with numbers on from day one.

Keep `window.vala` boring. Do not invent a sheet widget yet. Phase 03 replaces this content area.

Distro packages this phase needs:

- `vala`
- `meson`
- `gtk4`
- `libadwaita`
- `gtksourceview5`
- `pkgconf`

Pin GI versions in Vala: `Gtk`, `4.0`; `Adw`, `1`; `GtkSource`, `5`.

## Steps

1. Write the root `meson.build`. `project('calcumon', 'vala', 'c', version: '0.1.0')`. Find `gtk4`, `libadwaita-1`, `gtksourceview-5` via `dependency()`.
2. Add `src/meson.build` that builds executable `calcumon` from the three Vala files.
3. `main.vala` constructs `Calcumon.Application` and calls `run(args)`.
4. `application.vala` handles `activate` and owns the window.
5. `window.vala` builds the toolbar + source view. Set `hexpand`/`vexpand` so the editor fills the window. Default size around 800x600.
6. Add a `.desktop.in` so later install targets have something to show in a menu. Do not block the phase on icon artwork.
7. Confirm the binary runs under Wayland on this machine.

## Tests

No unit tests this phase. Manual:

- Launch, type several lines, resize, maximize.
- Toggle the desktop dark style and check the window follows it.
- Ctrl+Q or close button exits cleanly with no Vala/GTK warnings you introduced.

## Out of scope

Evaluation, results column, tabs, GSettings, JavaScriptCore, math.js, desktop icon design.
