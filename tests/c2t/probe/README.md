# c2t P0 probes

Measurements behind `C:\dev\docs\tiko-c2t\RFC-0001-c2t.md` §10, taken 2026-10-15 at tiko-lang
`aae74386`. Not part of `build/test.sh`; rerun by hand when libclang or the compiler moves.

| Item | Fixture | How to run | Result |
|---|---|---|---|
| 1 | `comments.h` | `python -I clangprobe.py <libclang> .` | `clang_tokenize` returns every comment as a `Comment` token (18, 21) |
| 2 | `skip.h` | same | each inactive region is one range: from column 1 of the directive that opens it to the end of the keyword of the directive that closes it; needs `DetailedPreprocessingRecord`; same with a preamble; identical on 18 and 21 |
| 3 | `extents.h` | same | expansion locations identical on 18 and 21, spelling locations differ; macro-made declarations are invisible to `clang_Location_isFromMainFile` |
| 4 | `tiko/fwd-*.tiko` | `bash run-tiko.sh` | `type X__fwd as X` + `X ptr` before a later definition is TKO0784; works for never-defined records; `X__fwd ptr` and `X__ptr` (an alias of `X ptr`) work before the definition |
| 5 | `tiko/layout.tiko` | same | one Windows process lays out both targets (`clong`, `wstring`), no sysroot |
| 6 | `tiko/externc.tiko` | same | `extern`, `extern import`, `type` blocks and `#if` all compile inside `extern "C"` |
| 7 | `tiko/enumsize*.tiko` | same | a tiko `enum` is 8 bytes on both targets |
| 8 | `tiko/cbool.c` + `cbool.tiko` | `clang --target=x86_64-pc-windows-msvc -c cbool.c -o cbool.o`, then a packaged tiko: `tiko cbool.tiko cbool.o` | `boolean` round-trips C `_Bool` both ways |
| 9 | `tiko/cont*.tiko` | `bash run-tiko.sh` | a comment after `_` and `/' '/` before `_` work; a comment-only or blank line inside a continued list is TKO0406; `_ '' text` and a bare `_` line work |
| 10 | `tiko/literals.tiko` | a packaged tiko, run the program | `f`/`!` single, `d`/`#` double, unsuffixed double; `\&o33` octal, `\27` decimal |
| 11 | `tiko/ppexpr.tiko` | `bash run-tiko.sh` | `iif`, `andalso`/`orelse`, `not defined()`, `shl`, `\` work in `#if`; comparison is -1; `__FB_WIN32__`/`__FB_LINUX__` and `TIKO_OS_*` follow `-target` |

`results-clang18.txt` (WSL, Ubuntu clang 18.1.3) and `results-clang21.txt` (Windows, LLVM 21.1.0)
are the two clang runs. The repo's `bin/tiko.exe` compiles but cannot link a program (no
`ucrtbase.lib` under `lib/`), so items 8 and 10 use `toolchains/tiko-windows/tiko.exe`; tiko
takes a C object as `.o`, not `.obj`.
