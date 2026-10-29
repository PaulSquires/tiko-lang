# tkEdit

A minimalist, keyboard-driven editor for the tiko language, on tkControls (SDL3 + SDL_ttf): one
editor fills the window, no toolbar and no tabs, a menu bar that shows only on Ctrl+Shift+M, and
configuration in TOML files only. Windows, Linux and macOS (Apple Silicon); on a Mac every Ctrl
chord below is Cmd.
Spec and records: `C:\dev\docs\tkEdit` (PLAN.md, KEYS.md, CONFIG.md, FINDINGS.md).

## Using it

```
tkEdit [files...]        restores the last session (or project), then opens the files
```

One tkEdit per user: launched again while one runs, it hands its files to that window (a bare launch
brings the window to the front) and exits; `[ui] single_instance = false` gives each launch its own window.

- **Buffers:** Ctrl+E lists them, Ctrl+Tab switches to the last one at once (keep Ctrl down and press Tab
  again for older ones), the status line's file name lists them too. Ctrl+\ and Ctrl+Shift+\
  split the window; Ctrl+Tilde moves between the panes and the output pane.
- **Finding:** Ctrl+F / Ctrl+H open a strip above the status line; Ctrl+G goes to a line;
  Ctrl+Shift+F searches every project file; Ctrl+P searches files and definitions; F4 lists the
  functions of the buffer (F4 again: of every open buffer). F12 goes to a definition, Alt+Left
  comes back.
- **Building:** a `.tkedit` project (Project menu) names the main file or a tiko.toml target.
  Ctrl+F5 compiles, F5 builds and runs, Shift+F5 runs, Ctrl+F7 checks the file, Ctrl+Shift+F5
  runs the buffer as it is. Errors open the output pane; Alt+PgDn walks them.
- **Configuring:** Ctrl+Comma opens settings.toml, Ctrl+K keybindings.toml, Ctrl+Shift+T the theme.
  Saving one applies it. Every key is listed in `docs/tkEdit/KEYS.md`.

## Layout

| Folder | Package | What |
| --- | --- | --- |
| `src/platform` | `tkp` | the only code that tests `TIKO_OS_*` |
| `src/core` | `tkc` | GUI-free modules, console-tested by `tests/coreall`; `tests/keysdoc` writes KEYS.md |
| `src/svc` | `tks` | background work: the tikoParser scanner, the build runner |
| `src/app` | `tka` | the window, on tiko's `vendor/tkControls` (it comes with the toolchain) |
| `fonts/`, `icons/`, `keywords/`, `lang/`, `themes/` | | resources found beside `bin/`; `lang/` = the es / fr / de catalogs |
| `src/app/res` | | `tkEdit.rc` + `tkedit.ico`: the exe's icon (Windows); `tools/make-icon.py` draws both icons |

Copied modules and their source: [PROVENANCE.md](PROVENANCE.md).

## Build and test

```bash
bash tools/test-win.sh
```

```bash
MSYS_NO_PATHCONV=1 wsl.exe -e bash /mnt/c/dev/tiko-lang/tkedit/tools/test-linux.sh
```

On the Mac, from its own tiko-lang clone (a tree `bin/tiko` from `build/build.sh`, which also
writes `bin/parser.dylib`; SDL3 from Homebrew):

```bash
bash tkedit/tools/test-mac.sh
```

```bash
bash tools/idiom.sh
```

`src/app/tiko.toml` puts the icon's `.rc` in a `[target.tkEdit.windows]` table (tiko-lang f9e6575ab or later).

A release build (the test scripts build debug) writes `bin/tkedit.exe` too, from `src/app`:

```bash
TKO_MODCACHE=/c/dev/tiko-lang/tkedit/out/modcache /c/dev/tiko-lang/toolchains/tiko-windows/tiko.exe build --profile release
```

`bin/` is the run folder (`bin/tkedit.exe` beside the SDL libraries and `scintk.dll`, which the
build copies in, and `parser.dll`, which the test scripts do); it is not tracked. To regenerate the key
reference after changing `src/core/cmdids`:

```bash
src/core/tests/bin/keysdoc.exe 'C:\dev\docs\tkEdit\KEYS.md'
```
