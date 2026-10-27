# tkEdit

A minimalist, keyboard-driven editor for the tiko language, on tkControls (SDL3 + SDL_ttf): one
editor fills the window, no toolbar and no tabs, a menu bar that shows only on Ctrl+Shift+M, and
configuration in TOML files only. Windows and Linux; macOS when tiko runs tkControls apps there.
Spec and records: `C:\dev\docs\tkEdit` (PLAN.md, KEYS.md, CONFIG.md, FINDINGS.md).

## Using it

```
tkEdit [files...]        restores the last session (or project), then opens the files
```

- **Buffers:** Ctrl+E lists them, Ctrl+Tab switches to the last one (keep Ctrl down and press Tab
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
| `src/app` | `tka` | the window, on tkControls (path dependency `../tkControls`) |
| `fonts/`, `keywords/`, `themes/` | | resources found beside `bin/` |

Copied modules and their source: [PROVENANCE.md](PROVENANCE.md).

## Build and test

```bash
bash tools/test-win.sh
```

```bash
MSYS_NO_PATHCONV=1 wsl.exe -e bash /mnt/c/dev/tkEdit/tools/test-linux.sh
```

```bash
bash tools/idiom.sh
```

`bin/` is the run folder (`bin/tkedit.exe` beside the SDL libraries, `scintk.dll` and
`tikoParser.dll`, which the test scripts copy in); it is not tracked. To regenerate the key
reference after changing `src/core/cmdids`:

```bash
src/core/tests/bin/keysdoc.exe 'C:\dev\docs\tkEdit\KEYS.md'
```
