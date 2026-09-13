# Calcumon plans

Calcumon is a notepad calculator. You type math in a text view. Each line gets an answer as you type. Notes and expressions share the same page. Pages are libadwaita tabs.

It is a GTK 4 app, not a web wrapper. Numara is the reference for how a sheet should feel. Read [docs/numara.md](../numara.md) for that product. These plans take the interaction model and a small sheet language. They do not clone Numara's Electron shell, settings dump, or extra CAS libraries.

Work one phase at a time. Finish 01 before 02. A later phase may name files from an earlier one. If a step fights the earlier API, change the earlier API rather than papering over it.

## Stack

- GTK 4 + libadwaita. `Adw.Application`, `Adw.ApplicationWindow`, `Adw.ToolbarView`, `Adw.TabView`.
- GtkSourceView 5 for the editor.
- Vala, built with Meson.
- math.js inside a JavaScriptCore context (`javascriptcoregtk`). One `math.parser()` per page, so `a = 2` on one line and `a * 3` on the next share scope.
- App id `dev.calcumon.Calcumon` until a real namespace exists.

If JavaScriptCore plus math.js turns into a mess of bindings and module loading, switch the app shell to GJS. Keep these product plans. The engine contract stays "evaluate this line in this page's scope" either way.

```
GtkSourceView --text changed--> sheet model --each line--> JSC + math.js
                                                          |
                                                          v
                                                   results pane
```

## Phases

| File | Ships |
| --- | --- |
| [01-skeleton.md](01-skeleton.md) | Window, header bar, empty GtkSourceView. No math. |
| [02-eval-engine.md](02-eval-engine.md) | Headless sheet evaluator on math.js. |
| [03-notepad-ui.md](03-notepad-ui.md) | Live two-column sheet. |
| [04-pages.md](04-pages.md) | Tabs, save, restore. |
| [05-sheet-language.md](05-sheet-language.md) | `ans`, `lineN`, totals, continue-from-previous. |
| [06-settings.md](06-settings.md) | A short GSettings list, About, shortcuts. |
| [07-combined-header.md](07-combined-header.md) | Tabs move into the header bar. One top row. |

Each phase file has the same shape: goal, done when, layout and API, steps, tests, out of scope.

## Non-goals

These stay out of every phase unless a later plan explicitly adds them.

- Function plots
- Downloaded currency rates
- Formula.js / Excel functions
- nerdamer
- Electron or a WebKit editor
- Tray icon, always on top
- Locale-specific input separators (comma as decimal on the typed line)
- Folder sync
- Printing
