# Vendored Scintilla and Lexilla — a FORK, not a release

| | version | upstream |
| --- | --- | --- |
| Scintilla | **5.5.7** (`version.txt` = 557) | https://www.scintilla.org |
| Lexilla | **5.4.5** (`version.txt` = 545) | https://www.scintilla.org/Lexilla.html |

Copied from `C:\dev\tiko_editor\scintilla_modified` on 2026-08-05, which is the tree tiko builds
against today. **It is a fork and is treated as ours**, which was a deliberate decision: the
alternative — pinning a clean upstream tarball and carrying the modifications as patches — keeps
the delta legible but makes every upgrade a merge, and this tree has already diverged in ways
that are not a patch series.

## How it differs from upstream, so far as is known

- **`lexilla/lexers/` contains exactly one lexer: `LexTiko.cxx`.** Upstream ships well over a
  hundred. Every other lexer has been removed, so this is not a pruned build of upstream, it is a
  different set. `LexTiko` is Paul Squires' FreeBASIC lexer and registers under `SCLEX_VB` (8).
- The tree carries MSVC project files and was built with Visual Studio; we build it with our own
  toolchain instead, so those are not vendored.

Changing the lexer set means re-running `lexilla/scripts/LexillaGen.py` (Python 3.7+) to
regenerate the catalogue, per the upstream note in the original tree's `readme_paul.txt`.

## What was NOT vendored, and why

The source tree at origin is **307 MB**; this is **2.1 MB**. Almost all of the difference is
build output, not code:

| excluded | size | why |
| --- | --- | --- |
| `scintilla/win32/Intermediates`, `win32/x64`, `lexilla/src/x64`, `lexilla/src/Lexilla` | ~130 MB | MSVC object files and binaries |
| `scintilla/win32`, `gtk`, `qt`, `cocoa` | ~2 MB of source | **the platform backends we are replacing.** `ScintillaWin.cxx` alone is 4,104 lines of Win32 message plumbing, OLE drag-and-drop and IME — all of it work the toolkit does through its own event system |
| `scintilla/doc`, `lexilla/doc` | 2.5 MB | HTML documentation, available upstream |
| `scintilla/test`, `lexilla/test` | 3.8 MB | upstream's own test suites, which test upstream's platform layers |
| `scripts/` | 190 KB | generators needed only when the lexer set changes; kept in the original tree |

What IS here is everything the core needs to compile: `scintilla/src` (33 `.cxx`),
`scintilla/include`, `scintilla/call`, `lexilla/{include,lexlib,lexers,src}`, and both licences.

## The licence

Scintilla and Lexilla are © Neil Hodgson and contributors, under the Scintilla licence — see
`scintilla/License.txt` and `lexilla/License.txt`. That is a permissive licence and is compatible
with this toolkit's MPL-2.0, but it is **their** licence and applies to everything under this
directory. The MPL-2.0 header that every other source file in this repository carries is
deliberately absent here.
