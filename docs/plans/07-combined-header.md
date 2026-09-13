# Phase 07. Combined header

Today the window has two bars stacked at the top: an `Adw.HeaderBar` with the app name and the menu button, then an `Adw.TabBar` under it. The header bar row spends ~47px on the word "Calcumon" and three window controls. For a calculator that lives in a small window that is a lot of empty space above the first line.

Put the tabs in the header bar. One row: tabs on the left and center, new-tab button, menu, window controls on the right. GNOME Console and Ptyxis do this.

## Goal

A single top bar that holds the tabs and the header controls. Roughly 40px more editor per window. No feature from phase 04 regresses.

## Done when

- There is one bar above the editor. Tabs, the new-page button, the main menu button, and the window controls share it.
- The bar is a window drag handle. Dragging on empty space to the right of the tabs moves the window. Double-clicking that empty space does what the desktop does (maximize), not rename.
- Double-click on a tab still renames it. Right-click on a tab still shows the Rename menu.
- `Ctrl+N`, `Ctrl+W`, tab reorder by drag, session restore, and rename persistence all still work.
- With one tab open the bar still shows that tab. It does not collapse to an empty header.
- At 400px window width the tabs scroll inside the bar rather than pushing the menu or window controls off screen.
- The window title (what the shell and task switcher show) still says Calcumon.

## Layout and API

```
src/
  window.vala         # header bar with tab bar as title widget
data/
  style.css           # inline tab bar tweaks, if any
```

**Widgets.** Keep `Adw.ToolbarView` with one top bar. The top bar is the existing `Adw.HeaderBar`. Set the `Adw.TabBar` as its `title_widget`. Add the `.inline` style class to the tab bar so it drops its own background and sits flush in the header. `hexpand = true` on the tab bar so it takes the width between the start and end packing areas.

```
Adw.ToolbarView
  top bar: Adw.HeaderBar
    title_widget: Adw.TabBar (.inline, view = tab_view, autohide = false)
      end_action_widget: new-page button
    pack_end: menu button
    (window controls come from the header bar)
  content: Adw.TabView
```

Keep `autohide = false`. With autohide on, a single tab hides the tab bar and the header shows nothing in the middle.

Keep `expand_tabs` at its default. If tabs look too wide with one or two pages open, set `expand_tabs = false` and let them size to their titles. Pick one after seeing it; do not add a setting.

Keep the new-page button as `tab_bar.end_action_widget`, next to the last tab. Moving it to `header.pack_end` would put it between the tabs and the menu with a gap. Either works; the action widget keeps it attached to the tabs.

**Rename gesture.** The current `Gtk.GestureClick` on the tab bar renames on any double-click, including empty space. That conflicts with the header bar's double-click-to-maximize once the two are the same widget. Restrict it: in the `pressed` handler, call `tab_bar.pick (x, y, Gtk.PickFlags.DEFAULT)` and walk up parents until a widget with CSS name `tab` is found or the tab bar is reached. Rename only if a tab was hit. If `pick` turns out unreliable for this, drop the double-click rename and keep the context menu entry plus a `F2` accelerator for `win.rename-page`. Do not keep a gesture that steals maximize.

**Window title.** The header no longer shows "Calcumon". Leave `Window.title` set so the shell has a name. Optional: bind it to `"<page title> — Calcumon"` on `selected-page` change. One line in `on_selected_changed`, plus the rename handler. Skip it if it complicates the restore path.

**Fallback.** If `Adw.HeaderBar` refuses to give the title widget the full center width (it should under the default `LOOSE` centering policy, but check), build the bar by hand: `Gtk.WindowHandle` containing a horizontal `Gtk.Box` with the inline tab bar (`hexpand`), the menu button, and a `Gtk.WindowControls (END)`. Add the `.toolbar` or `headerbar` styling as needed. This is more code and loses the header bar's automatic decoration-layout handling, so only do it if the title widget approach fails.

## Steps

1. In `Window` construct: remove `toolbar_view.add_top_bar (tab_bar)`. Set `header.title_widget = tab_bar`. Add `tab_bar.add_css_class ("inline")`, `tab_bar.hexpand = true`.
2. Run it. Check the three widths: default 800px, maximized, and 400px. Check one tab, three tabs, ten tabs.
3. Fix the rename gesture as described. Verify double-click on empty header space maximizes and on a tab renames.
4. Check drag-to-move from empty bar space and from a tab. Dragging a tab should reorder, not move the window. libadwaita handles this; confirm.
5. Adjust `style.css` only if the inline tab bar has visible padding or a border that does not match the header. Prefer no CSS.
6. Decide `expand_tabs` by looking at it. Commit one value.
7. Update the phase 04 note that says "Put `Adw.TabBar` under the header bar" with a pointer to this phase. Do not rewrite 04.

## Tests

Manual:

- Open with one restored page. The bar shows that tab, the + button, the menu, and window controls. No second row.
- `Ctrl+N` three times. Tabs appear in the bar. Drag the third tab to first position. Quit, reopen. Order kept.
- Double-click a tab. Rename dialog. Double-click empty space right of the tabs. Window maximizes (or whatever the desktop's titlebar double-click action is).
- Drag empty bar space. Window moves. Drag a tab. Tab reorders, window stays.
- Resize to 400px wide with eight tabs. Tabs scroll. Menu and window controls stay visible and clickable.
- Close all tabs with `Ctrl+W`. A fresh empty page appears and the bar still shows one tab.
- Measure: editor line 1 sits about 40px higher than before at the same window size.

## Out of scope

Hiding the bar entirely, fullscreen mode, vertical tabs, tab overview (`Adw.TabOverview`), pinned tabs, moving the menu into a tab-bar action widget, custom window decorations, a setting to switch back to two rows.
