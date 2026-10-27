# tkFontList: notes

tkFontList is new in tkControls (tiko-studio P3, PLAN.md deficiency 7). It replaces
tiko-editor's `EnumFontFamilies`: SDL_ttf opens files and lists none, and fontconfig is not a
dependency tkControls takes.

**What it does:**
- `tkFontList_Scan( dirs )` walks the folders (std/fs `WalkDir`) and opens every face of every
  `.ttf` / `.otf` / `.ttc`, recording family, style, bold, italic and fixed pitch. With no dirs it
  scans `tkFontList_SystemDirs()`: `%WINDIR%\Fonts` plus the per-user folder on Windows,
  `/usr/share/fonts`, `/usr/local/share/fonts` and `~/.local/share/fonts` on Linux, and three
  folders on macOS.
- **A face of a collection** is `"path|Family"`: the spelling tkCodeEdit takes, where the family
  selects within the `.ttc` (MS Gothic and MS UI Gothic share `msgothic.ttc`).
- `tkFontList_Families( bMonoOnly )` returns them sorted and unique.
- `tkFontList_Find( family, bold, italic )` returns the file. A missing cut falls back to the
  regular face, then to any face of the family.

**tkApp change.** When the files the options name are missing (any machine but Windows),
`tkApp_Init` picks installed families through `tkApp_FallbackFont`: Segoe UI → Noto Sans →
DejaVu Sans → Ubuntu → Liberation Sans → … for the UI, and Cascadia Mono → Consolas → DejaVu Sans
Mono → … for mono. `tkApp_DefaultFontDir` on Linux is `/mnt/c/Windows/Fonts` only when that
exists (WSL), `/usr/share/fonts` otherwise. tkApp imports tkFontList BEFORE tkHost: std/fs must
precede vendor/SDL3 on Linux.

**Measured (2026-10-25):**
- Windows' fonts folder: 485 faces in 60 ms.
- examples/tkControls/tkFontList 14/14 and examples/tkControls/tkApp 62/62 on Windows, X11 and Wayland. Linux's own folders
  give DejaVu Sans / Sans Bold / Sans Mono as the fallbacks; Windows gives Segoe UI / Segoe UI
  Bold / Cascadia Mono.
- A/B plant: mono asked of the UI family list failed "the mono one is fixed pitch"; reverted.
  The same run also failed tkApp's "an unclaimed key bubbles to OnKeyDown". That check has nothing
  to do with fonts and passed before and after: a one-off, recorded.

**Not verified:**
- macOS folders.
- Variable fonts' named instances: one face is recorded per file face, not per instance.
