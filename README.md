# tkEdit

A minimalist, keyboard-driven editor for the tiko language, on tkControls (SDL3 + SDL_ttf):
one editor fills the window, a hidden menu bar, TOML-only configuration. Windows and Linux;
macOS later. Spec and records: `C:\dev\docs\tkEdit` (PLAN.md).

## Layout

| Folder | Package | What |
| --- | --- | --- |
| `src/platform` | `tkp` | the only code that tests `TIKO_OS_*` |
| `src/core` | `tkc` | GUI-free modules, console-tested by `tests/coreall` |
| `src/svc` | `tks` | background work: tikoParser scanner, build runner |
| `src/app` | `tka` | the window, on tkControls (path dependency `../tkControls`) |
| `fonts/`, `keywords/` | | resources found beside `bin/` |

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

`bin/` is the run folder (`bin/tkedit.exe` beside the SDL libraries, `scintk.dll`, and later
`tikoParser.dll`); it is not tracked.
