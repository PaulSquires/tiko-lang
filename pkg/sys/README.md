# sys

The tiko system package: platform APIs, shipped with the compiler beside `std` and imported as
`#import "sys/windows"`. Unlike `std` it is not reserved: a project's own package named `sys`,
found first, is the one it gets.

## sys/windows

A **facade** over `windows.bi` (ADR 0017 §19), the Windows API as the toolchain's `inc/` declares
it. It includes the header and re-exports its names under the import's alias:

```freebasic
#import "sys/windows" as win

dim as win.WNDCLASSEX wc                 ' WNDCLASSEXW
wc.cbSize = sizeof( win.WNDCLASSEX )
wc.hCursor = win.LoadCursor( 0, win.IDC_ARROW )
win.MessageBox( 0, "text", "caption", win.MB_OK )
```

**What its names are:**
- **The header's own.** A `win.RECT` *is* the `RECT` of a program, or of AfxNova, that
  includes `windows.bi` itself, and the two mix freely. The header travels with the module's
  interface, so its names are there bare too, as after an `#include`.
- **W, whatever UNICODE says.** An unsuffixed name is the Unicode one: `win.MessageBox` is
  `MessageBoxW`, `win.WNDCLASSEX` is `WNDCLASSEXW`, `win.TCHAR` is `WCHAR`, `win.LPTSTR` is
  `LPWSTR`, and `win.IDC_ARROW` and `win.SE_DEBUG_NAME` are wide. The A and W names are there
  as well, as spelled. A program's own bare names still follow its UNICODE.
- **Qualified only.** The names are exported macros, reached as `alias.NAME`; `using win` does
  not make them bare.
- **Keywords keep the header's spelling.** `windows.bi` renames the API names that are
  FreeBASIC keywords -- `Sleep_`, `Beep_`, `BGR` for Windows' RGB, `ERROR_`, `CTRUE` -- and so
  does the facade. `POINT` is not exported (`alias.KEYWORD` never expands): write `win.tagPOINT`,
  or `POINT` bare.
- **`LOWORD`, `HIWORD`, `LOBYTE`, `HIBYTE`** are FreeBASIC's own macros, exported as they are.
- **Not yet seen by the tooling.** tiko-lsp's completion and the editor's parser list a
  module's public symbols, and exported macros are not symbols.

**Left out:** names beginning `_` (MinGW's plumbing), the C runtime headers `windows.bi`
pulls in, and the four names the header declares only with UNICODE or only without (listed at
the top of `windows.bas`). What `windows.bi` leaves out -- `commctrl.bi`, `shellapi.bi`,
`WIN_INCLUDEALL` -- the facade leaves out too.

**Linking** is the header's: its `#inclib` lines.

## Regenerating

`windows/windows.bas` is written by `build/genwinfacade.py` from the header itself, using
`tiko --dump-scan` without and with UNICODE, so the names and their W forms come from the
compiler. It takes a few minutes. Re-run it from the repository root whenever `windows.bi`
changes, and commit the result:

```sh
python build/genwinfacade.py            # rewrite the facade
python build/genwinfacade.py --check    # exit 1 if it would change
```

`build/package.sh --verify` builds and runs a program importing it, per Windows target.
