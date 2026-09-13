# Phase 04. Pages

One sheet is a scratchpad. Tabs make it an app you keep open.

## Goal

Multiple pages in `Adw.TabView`. Each page is its own `SheetView` and `SheetEngine`. New, close, rename. Pages survive a quit.

## Done when

- The window opens with at least one tab. A "+" or `Ctrl+N` creates another.
- Each tab has an independent buffer and variable scope. `a = 1` on page A does not define `a` on page B.
- Closing a tab drops that page. Closing the last tab creates a fresh empty one rather than leaving a hole. Quitting the app is a separate action.
- Rename works from the tab (double-click or a header menu). The title is what persistence stores.
- Quit and relaunch restores page titles, text, tab order, and which tab was active.
- Dirty typing saves without an explicit Save command. A debounce around 500ms after the last edit is enough.

## Layout and API

```
src/
  page.vala           # id, title, text; load/save
  page-store.vala     # user-data dir, session
  window.vala         # Adw.TabView + TabBar
```

**Widgets.** `Adw.ToolbarView` top bar stays. Put `Adw.TabBar` under the header bar, bound to `Adw.TabView`. Each `Adw.TabPage` child is a `SheetView`. `Adw.TabView.create_window` can stay unimplemented. We are not doing split windows. Phase 07 moves the tab bar into the header.

**`Page`.** `string id` (UUID), `string title`, `string text`. Default title "Page" or "Page N". Id never changes. Title changes on rename.

**On disk.** Directory `GLib.Environment.get_user_data_dir() + "/calcumon/pages/"`. One JSON file per page, named `{id}.json`:

```json
{
  "id": "...",
  "title": "Rent",
  "text": "1200 + 250\n",
  "order": 0
}
```

Sibling file `session.json`: `{ "active_id": "...", "ids": ["...", "..."] }`. `ids` is tab order. If `session.json` and the page files disagree, trust `ids` and skip missing files.

Write pages atomically. Write to `{id}.json.tmp`, then rename. A crash mid-write should not truncate the last good file.

**`PageStore`.** `load_all()`, `save(Page)`, `delete(id)`, `save_session(...)`. Window calls these. Do not have `SheetView` know about paths.

**Lifecycle.**

- Launch: `PageStore.load_all()`. If none, create one empty page.
- `Ctrl+N` / new-tab button: empty `Page`, new `SheetView`, append, select it, persist.
- Close tab: persist-delete that id, then `TabView.close_page`. If zero tabs remain, create empty.
- Buffer changed: debounce, write that page's JSON, also write session if the active tab changed.
- Rename: update `Page.title`, `tab_page.set_title`, save.

Do not confirm on close. This is a calculator, not a novel. Persistence is continuous, so close is not data loss.

## Steps

1. Add `Page` and `PageStore`. Unit-test load/save against a temp dir if that is easy in Vala; otherwise a tiny test binary.
2. Rebuild `Window` around `Adw.TabView`. One `SheetView` per tab.
3. Hook new / close / rename. `Ctrl+N`, `Ctrl+W`.
4. Restore session on `activate` before the window is shown, so users do not see an empty flash then a fill.
5. Handle a corrupt JSON file by skipping it and keeping the others. Log a warning. Do not refuse to start.

## Tests

Manual:

- Two pages, different variables, switch tabs. Scopes stay separate.
- Rename, quit, reopen. Name and text still there. Active tab is the one you left on.
- Kill the process while typing. Relaunch. Last debounced save is present. You may lose the last few hundred milliseconds of keystrokes. That is acceptable.
- Close the last tab. A new empty page appears. Quit and reopen still has one empty page, not zero and not the deleted content.

## Out of scope

Export/import, `.num` files, folder sync, cloud, undo-close-tab, pin tabs, tab colors, search across pages.
