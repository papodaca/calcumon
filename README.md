# Calcumon

A notepad calculator. Type math in a text view. Each line gets an answer as you type. Notes and expressions share the same page, and pages are tabs.

GTK 4 and libadwaita, not a web wrapper. [Numara](https://numara.io) is the reference for how a sheet should feel. Evaluation uses [math.js](https://mathjs.org) inside JavaScriptCore. One parser per page, so a value defined on one line is in scope on the next.

```
rent = 1400
groceries = 320
rent + groceries     // 1720
5 cm + 2 in
sin(pi / 2)
```

## What you type

A line is math, a comment, or both. `#` and `//` cut the rest of the line. Blank lines stay blank. Assignments persist for later lines on that page only. `a = 1` on one tab does not define `a` on another.

Keywords:

- `ans` previous answer
- `lineN` answer from line N, 1-based
- `total` sum of numeric answers so far
- `subtotal` same, starting after the last blank line
- `avg` mean of the same set `total` uses
- `today` today's date
- `now` today's date and time

`today + 3 weeks` and `now + 36 hours` add a duration. `10% of 20` is 2, and `40 + 5%` is 42. `8 % 3` is still modulus.

If a line starts with `+`, `-`, `*`, or `/`, it continues from the previous answer. Turn that off in preferences.

```
100
+ 20
* 2
total
```

gives 100, 120, 240, 460.

`ans`, `total`, `subtotal`, `avg`, `today`, `now`, and `lineN` are reserved. You cannot assign to them.

math.js supplies the rest: functions, units, constants. See the [math.js docs](https://mathjs.org/docs/index.html). There are no plots, downloaded currency rates, or Excel functions. Those stayed out on purpose.

## Build from source

Needs Meson 1.0+, Vala, GTK 4.14+, libadwaita 1.5+, GtkSourceView 5, JavaScriptCoreGTK 6, and json-glib.

On Arch / CachyOS:

```
sudo pacman -S meson ninja vala pkgconf gtk4 libadwaita gtksourceview5 webkitgtk-6.0 json-glib
```

Meson asks for `javascriptcoregtk-6.0`. Arch does not package JSC on its own, so that pkg-config file lives in `webkitgtk-6.0`. The binary links `libjavascriptcoregtk` only, not the WebKit webview. Debian already splits them (`libjavascriptcoregtk-6.0`).

```
meson setup build
meson compile -C build
meson devenv -C build ./src/calcumon
```

`meson devenv` points GSettings at the uninstalled schema. Running the binary from `build/src` without that will warn and use defaults.

To install:

```
meson setup build --prefix=/usr
meson compile -C build
sudo meson install -C build
```

## Packages

Tagged releases on [GitHub](https://github.com/papodaca/calcumon/releases) ship an Arch `.pkg.tar.zst`, an AppImage, and a Flatpak bundle. The AppImage is built on Ubuntu 26.04, so it needs a glibc at least that new.

From a checkout on Arch:

```
cd packaging/arch
makepkg -si
```

That builds the git tree two directories up, not an AUR tarball.

Docker smokes that match CI:

```
./packaging/arch/smoke-docker.sh
./packaging/appimage/smoke-docker.sh
./packaging/flatpak/smoke-docker.sh
```

The Flatpak smoke needs `--privileged` for nested bubblewrap.

## Tests

```
meson test -C build --print-errorlogs
```

`engine` covers the sheet language. `page-store` covers save and restore. `sheet-smoke` opens a GtkSourceView sheet without a window manager.

## Data

Pages live under `~/.local/share/calcumon/`. Each tab is a JSON file. `session.json` remembers order and the active tab. Edits save about 500 ms after you stop typing. There is no Save command.

Preferences are GSettings schema `dev.calcumon.Calcumon`: font size, line numbers, continue-from-previous, precision. Theme follows the desktop.

## Shortcuts

| Key | Action |
| --- | --- |
| Ctrl+N | New page |
| Ctrl+W | Close page |
| Ctrl+Q | Quit |
| Ctrl+, | Preferences |
| Ctrl++ | Larger font |
| Ctrl+- | Smaller font |
| Ctrl+? | Shortcuts overlay |

Double-click a tab to rename it. Click an answer to copy it. A failed line shows Error; hover for the message.

## License

MIT. Bundled math.js is Apache-2.0.
