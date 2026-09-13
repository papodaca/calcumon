# Phase 06. Settings

A short preferences list. Numara's settings screen is a product of years of Electron. Do not port it.

## Goal

GSettings for the few knobs the sheet actually needs, an About dialog, and the shortcuts already implied by 04. Theme follows the desktop.

## Done when

- Font size, line numbers, input wrap, and answer position persist across launches.
- Changing a setting updates the open tabs without a restart.
- Answer position `right` is today's two-column layout. `below` prints each answer under its expression in the results column or in a stacked layout that still maps 1:1 to lines. If `below` cannot stay aligned, ship `right` only and leave `below` unimplemented rather than shipping a broken mode.
- Line numbers can be hidden. Wrap, if enabled, must keep editor rows paired with answers. If wrap breaks pairing, the wrap switch stays off / insensitive and a comment in code explains why.
- About dialog shows app name, version from Meson, and "math.js" as the evaluator.
- System light/dark is enough. No in-app theme picker.

## Layout and API

```
data/
  dev.calcumon.Calcumon.gschema.xml
src/
  settings.vala       # thin GLib.Settings wrapper
  window.vala         # Preferences window or Adw.PreferencesDialog
```

Schema id `dev.calcumon.Calcumon`, path `/dev/calcumon/Calcumon/`.

| Key | Type | Default |
| --- | --- | --- |
| `font-size` | `i` | `14` |
| `show-line-numbers` | `b` | `true` |
| `wrap-input` | `b` | `false` |
| `answer-position` | `s` | `'right'` |
| `continue-from-previous` | `b` | `true` |
| `precision` | `i` | `4` |

`precision` feeds math.js `format` in `SheetEngine`. Range 0 to 16. Clamp in the UI.

`continue-from-previous` is the flag from phase 05. Put it here so it is not a hidden constant.

**UI.** `Adw.PreferencesDialog` from a header-bar menu (hamburger). Two pages is plenty: Editor (`font-size` as `Adw.SpinRow` or a few size chips, line numbers, wrap) and Calculator (answer position, continue-from-previous, precision). Do not add notification toasts, locale lists, or currency intervals.

Font size applies to both columns in every `SheetView`. Connect to `GLib.Settings.changed` and restyle. Do not rebuild tabs.

**Shortcuts.** Document in the About or a `Ctrl+?` overlay if you want one. Minimum:

- `Ctrl+N` new page
- `Ctrl+W` close page
- `Ctrl+Q` quit
- `Ctrl++` / `Ctrl+-` font size

**About.** `Adw.AboutDialog`. Developer name can be a placeholder. Website optional. License: pick one when the repo exists. MIT matches Numara if you want the same.

## Steps

1. Write the gschema. Install it in Meson (`gnome.compile_schemas` / `install_data`). Set `GSETTINGS_SCHEMA_DIR` for uninstalled runs.
2. `Settings` helper that reads/writes the keys with getters the rest of the app can call.
3. Preferences dialog. Wire rows two-way to GSettings.
4. Apply font size, line numbers, wrap, precision, continue-from-previous to existing `SheetView`s.
5. Answer position only if the layout still lines up. Otherwise omit the row.
6. About + shortcuts.

## Tests

Manual:

- Change font size, close preferences, type. Both columns use the new size. Quit and reopen. Size kept.
- Toggle line numbers. Alignment with answers still holds.
- `continue-from-previous` off, type `100` then `+ 20`. Does not become 120.
- Precision 0 vs 4 on `1/3`.
- Uninstalled run still finds the schema (`GSETTINGS_SCHEMA_DIR` in a meson devenv or a wrapper script).

## Out of scope

Theme customizer, always on top, tray, start-with-blank-page vs last page (04 already restores the session), keyword tooltips, autocomplete, bracket match settings, thousands separators, locale, currency, plot axis, notifications, reset-all-data, sync folder.
