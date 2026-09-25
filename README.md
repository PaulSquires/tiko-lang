# tiko-lang

**tiko is a FreeBASIC-compatible compiler, written from scratch in FreeBASIC.** It has its own
frontend and its own typed IR, emits LLVM IR, and hands that to clang. It targets Windows x86-64
and Linux x86-64 and compiles `#lang "fb"` only. The repository is tiko-lang; the compiler, its
binary and its `TKO` diagnostics are all tiko.

> **Status.** Every figure here carries its date and its source. tiko compiles FreeBASIC programs
> to executables, DLLs and static libraries, and **it compiles itself**: stage2 and stage3 are
> byte-identical files on win64-msvc and linux-x86_64, at `-O0` and at `-O2` (`build/bootstrap.sh`,
> HANDOFF §9d, 2026-09-21).
>
> Measured against fbc, which is the ground truth for every compatibility question:
>
> - **fbc's own test corpus** is vendored in `tests/vendor/` and is the acceptance gate. All 68
>   in-scope programs tagged `COMPILE_AND_RUN_OK` print what fbc's build prints, byte for byte.
>   The other 35 of the 103 are `qb`, `fblite` or `deprecated` dialect files, which are out of
>   scope. Of fbc's fbcunit suites, 631 build and run under both compilers and 495 give the same
>   results table (HANDOFF §9c, 2026-09-20).
> - **Fuzzing:** 2,000 generated programs, every one byte-identical to fbc's output (§9c).
> - **Real code:** all 28 PsControls demos compile and link, and 27 capture pixel-identical to
>   their fbc builds. PsProgressBar is the 28th; it animates, and two fbc runs of it differ too
>   (commit 893c8d49, 2026-09-15). tiko-editor's 100k-line unity build compiles (§9a); running it
>   has not been verified.
> - **Speed:** every front-end budget is met. End to end, tiko is 1.04–1.19× slower than fbc
>   `-gen gcc` to an executable, and the difference is the link (§9c).
>
> **Still open:** Phase 12 (real-world compatibility) and Phase 14 (optimiser, debug info,
> hardening). `--bootstrap-subset-check` is parsed but checks nothing yet. The plan and its phases
> are in [`docs/plan/`](docs/plan/README.md).

**Picking this up cold? Start with [HANDOFF.md](HANDOFF.md)** — current state, the open bugs with
reproducers, and what to do next. Read it bottom-up: later sections supersede earlier ones.

## What it compiles

The dialect is `#lang "fb"` as [FBC-Modern](https://github.com/PaulSquires/fbc-modern)
implements it: FreeBASIC 1.20.0 plus FBC-Modern's extensions. tiko reports `__FB_VERSION__` as
`"1.20.0"`.

It compiles these extensions:

- generics
- `FOR EACH` and the iterator protocol
- tuples and multiple return
- `defer`
- lambdas, capturing and not
- `USTRING`
- `spawn`, `Channel` and `select channel`
- `#foreignlib`
- `#cinclude`, which imports a C header itself through libclang, loaded at first use
  ([D16](docs/architecture/decisions/0016-cinclude.md))

It also compiles the library headers written on top of them: the containers, sorting,
`Optional`/`Result`, `SharedPtr`, `ComPtr`, `fb/chrono.bi`, `fb/filesystem.bi` and `fb/string.bi`.
The evidence is the corpus's `generics/`, `tuple/`, `com/` and `chrono/` programs matching fbc,
and tiko's own source, which uses generics, `FOR EACH`, `fb/array.bi` and `fb/filesystem.bi`.

The language reference is the [wiki](wiki/Home.md): the FreeBASIC manual, plus a page for every
extension ([Feature Index](wiki/Feature-Index.md)). [Compatibility](wiki/Compatibility.md) says
what differs from fbc.

**Not supported.** Each of these is a diagnostic, not a silent difference (measured 2026-09-24):

| Construct | tiko says |
| --- | --- |
| `#lang "qb"`, `"fblite"`, `"deprecated"` | `TKO0317: unsupported language mode` |
| `GOSUB` | `TKO0409: 'GOSUB' is not available in the fb dialect` |
| inline `ASM` | `TKO0407: inline assembly is not supported; compile that module with fbc` |
| `-m32`, `-target win32` | `TKO0104` / `TKO0103` — x86-64 only; 32-bit was removed 2026-09-04 (D14) |
| fbc's `-gen`, `-lang`, `-x`; FBC-Modern's `-cprobe`, `-cimport-split`, `-cimport-indir` | `TKO0100: unknown option` — there is one backend and one dialect |

**Also different:**

- tiko defines `__TIKO_COMPILER__` as `1`: test it with `#ifdef __TIKO_COMPILER__`. It does
  **not** define `__FB_MIN_VERSION__`, so `#if __FB_MIN_VERSION__( ... )` is an error.
- tiko defines `__TKO_VERSION__` of its own. It sets `__FB_SIGNATURE__` to `"tiko-lang"` and
  `__FB_BACKEND__` to `"llvm"`.
- There is no macOS target and no ARM64 target.

**Known gaps.** Measured 2026-09-24 at 50c71751 against fbc-modern's builds of the same programs,
and listed with the rest on [Compatibility](wiki/Compatibility.md):

- **tiko accepts some programs fbc rejects** (measured 2026-09-25):
  - a method parameter named like a member of its own type (4)
  - `#define` of a name fbc's runtime predeclares, `#define run 5` (4)
  - `print len`, `print sqr( )` and other keyword builtins with no operand (6, 9), whose
    statement tiko drops
- **fbc's own fbcunit suites:** across the whole corpus, 136 of 631 gave different results at §9c
  (2026-09-20). The extension libraries' own suites all match now: chrono, finance, filesystem,
  math, logging, tui and `fb/string.bi` (2026-09-24). The differences left in `string/` and
  `wstring/` are FreeBASIC's core string tests.
- **Many of fbc's diagnostics for the extensions are not raised yet.** 17 of fbc's 20 tuple error
  cases compile under tiko, and so do 1 of its 30 generics `fail-*.bas` files and a bare
  `DEFER`; some of them drop a statement silently. The [Generics](wiki/Category-Generics.md),
  [Tuples](wiki/Category-Tuples.md) and [Defer](wiki/Category-Defer.md) pages list them case by
  case.

## Compatibility, defined

- **The same accept/reject decision** as fbc in `-lang fb`, and **the same observable
  behaviour**: what the program prints, returns, and does ([D4](docs/plan/README.md)).
- **Byte-identical symbol names** ([D3](docs/plan/README.md)). An object tiko builds for
  `-target win64` links with fbc's, both ways, and `build/crosslink.sh` runs that in the gate.
  Only `win64` can meet fbc at all, because fbc has no MSVC target.
- **The runtime ABI is libfb's**: its `FBSTRING` and `FBARRAY` layouts and its `fb_*` signatures.
  tiko links **tiko-rt**, a reimplementation of that ABI in FreeBASIC (`lib/rt/`), and
  **libtkogfx**, a drop-in for fbc's graphics library (`lib/gfx/`).
- **The diagnostic text is tiko's own.** Every message has a stable `TKOnnnn` id from
  `src/diag/diagids.bi`. fbc's error numbers survive only where a program can see them, through
  `ERR`.

## Requirements

- **clang 18 or newer**, which is not bundled. tiko does not search `PATH`. It runs
  `C:\Program Files\LLVM\bin\clang.exe` on Windows and `/usr/bin/clang` on Linux, or whatever
  `TKO_CLANG` names. It takes `llvm-ar` and `llvm-rc` from the same directory. It links with lld,
  or on Linux with the system `ld` when there is no `ld.lld`. A Linux link also needs libtinfo.
- **To build tiko:** FBC-Modern's `fbc` as stage0. It is looked for at
  `C:\dev\fbc-modern\toolchains\fbc-modern-windows\fbc64.exe`, and `TKO_STAGE0` overrides that.
  Packaging a toolchain also reads FBC-Modern's tree (`--fbc-tree` or `FBC_TREE`) for its
  headers and its CRT objects.

## Quick start

`toolchains/` holds only READMEs; the toolchains themselves are build products. Package one for
the host you are on, from Git Bash on Windows or from Linux or WSL:

```bash
bash build/package.sh --verify
```

That builds the compiler, tiko-rt and libtkogfx at `Release`, and assembles
`toolchains/tiko-windows/` or `toolchains/tiko-linux/`. It then compiles **and runs** a program
per target and records the result in `MANIFEST.txt`. See
[toolchains/README.md](toolchains/README.md).

`hello.bas`:

```basic
#include once "containers.bi"
using FB

function MinMax( a as Array( of long ) ) as (lo as long, hi as long)
    dim as long lo = a[ 0 ], hi = a[ 0 ]
    for each v as long in a
        if v < lo then lo = v
        if v > hi then hi = v
    next
    return (lo, hi)
end function

dim xs as Array( of long )
xs.Push( 7 ) : xs.Push( -2 ) : xs.Push( 40 )

var (lo, hi) = MinMax( xs )
print "hello from tiko"
print xs.Count( ) & " values, from " & lo & " to " & hi
```

```bat
toolchains\tiko-windows\tiko.exe hello.bas
hello.exe
```

```bash
toolchains/tiko-linux/bin/tiko hello.bas
./hello
```

```
hello from tiko
3 values, from -2 to 40
```

No flags are needed. tiko finds `inc/` and `lib/<target>/` relative to its own executable. The
default target is the host's: `win64-msvc` on Windows, which needs no Visual Studio, and
`linux-x86_64` on Linux. `-target win64` selects the MinGW ABI.

## Command line

`tiko --help` lists every option; `tiko --help=<category>` lists one category. The ones in daily
use:

| Option | |
| --- | --- |
| `-o <file>` | output path; defaults to the first input's name |
| `-c` · `-dll` · `-lib` | object only · a DLL / shared object · a static library |
| `-target <name>` | `win64-msvc` (Windows default), `win64` or `linux-x86_64` (Linux default) |
| `-O<n>` | optimisation level 0–3, written joined: `-O2` |
| `-g` | debug information: DWARF line tables |
| `-e` · `-ex` · `-exx` | runtime error checking, up to array bounds and null pointers |
| `-mt` | the thread-safe runtime |
| `-i <dir>` · `-p <dir>` · `-l <name>` · `-d <name=val>` | include path · library path · library · define |
| `-s gui` | a Windows GUI-subsystem executable |
| `--diagnostics-file <path>` | also write every diagnostic as tab-separated records |
| `-v` | echo every tool invocation |
| `-cimport <h> -cimport-out <file>` | write a C header's FreeBASIC binding to a file; `#cinclude` does it in place |

`TKO_INCLUDE` replaces the bundled `inc/`. `TKO_LIBPATH` replaces the bundled library
directories.

## Building from source

```bash
bash build/build.sh Debug --test-runner   # bin/tiko[.exe] and bin/tiko-test[.exe]
bash build/test.sh                        # rebuilds only when stale, then runs the suite
bash build/lint.sh                        # layering and style rules, 1500-line cap per file
```

- **Configurations:** `Debug` (`-g -exx`), `RelWithDebInfo` (`-g`) and `Release`. All three must
  build.
- **`bin/tiko.exe` has no `inc/` or `lib/` beside it.** To link with it, set `TKO_INCLUDE` and
  `TKO_LIBPATH`, or pass `-i` and `-p`, for example at a packaged toolchain's `inc/` and
  `lib/win64-msvc/`.

| Script | What it is for |
| --- | --- |
| `build/check.sh` | the fast gate for one change: Debug build, suite, lint |
| `build/check-all.sh` | the full gate for a batch: every configuration, every gate against fbc, the corpus sweep |
| `build/bootstrap.sh` | the self-hosting fixpoint, stage0 → stage3, with `--gate` for the suite against stage2 |
| `build/package.sh` | a distributable toolchain for the host |
| `build/sweep.sh` · `mirsweep.sh` | the corpus through the front end · through lowering |
| `build/icescan.sh` · `linkscan.sh` | the corpus compiled to objects · linked |
| `build/runscan.sh` · `suiterun.sh` · `goldenrun.sh` | programs, fbcunit suites and test sources, run under tiko and fbc and compared |
| `build/crosslink.sh` | fbc's objects linked with tiko's, both ways |
| `build/perf.sh` | the performance budgets |

The runtime and the graphics library build themselves: `lib/rt/build/build.sh` and
`lib/gfx/build/build.sh`.

## Tests

- **`build/test.sh`** runs the suite under `tests/`: one `.test` file per case, with goldens in
  `expected/` beside it. `tests/mir/` and `tests/pp/` run every case for both `win64` and
  `linux-x86_64`, because what they dump depends on the target and not on the host. On
  2026-09-24 it was 1058 passing and none failing, in a clean checkout on Windows.
- **`tests/vendor/`** is fbc's own test suite, vendored unmodified from FBC-Modern (commit
  `ca1ea2fc`, 3,229 files, 2,709 of them `.bas`). It is never edited. The scan scripts above run it
  differentially against fbc.
- **tiko-rt** is gated with fbc's suite compiled against it: 3,922,097 assertions, 0 failures on
  win64-msvc (`lib/rt/build/gatemsvc.sh`, HANDOFF §9e).

## Layout

```
src/          THE COMPILER -- 107 modules
  support/       arenas, string interning, UTF-8/UTF-16, terminal detection
  diag/          the diagnostic id table, engine and renderer
  source/        source manager: files, encodings, locations, line index
  lexer/         token model, generated keyword vocabulary, the scanner
  pp/            the preprocessor: includes, macros, conditionals, builtins
  ast/           the node model: an index-addressed arena
  parser/        precedence table, Pratt expressions, statements, intrinsics
  types/         the type model and its target-injected layout
  symbols/       declarations, scopes, resolution, checking, overloads, generics, mangling
  mir/           the typed IR, its lowering and its verifier
  codegen/       ABI lowering, the LLVM IR emitter, debug info, clang and lld
  cimport/       #cinclude and -cimport: libclang, declarations, records, macros, names
  driver/        option table, command line, pipeline orchestration

lib/rt/       tiko-rt -- libfb's ABI, reimplemented in FreeBASIC
lib/gfx/      libtkogfx -- a drop-in for libfbgfx (win64-msvc)

toolchains/   the distributable Windows and Linux builds (READMEs only in git)
build/        build, test, lint, bootstrap, packaging and corpus scripts
tools/        tiko-test, the generators, the fuzzer, the corpus vendoring script
tests/        the suite; tests/vendor/ is fbc's corpus
docs/         plan/, architecture/decisions/, internals/, language/
wiki/         the language reference
```

## Documentation

| Document | What it covers |
| --- | --- |
| [HANDOFF.md](HANDOFF.md) | current state, open bugs with reproducers, what to do next |
| [docs/plan/](docs/plan/README.md) | the architecture and implementation plan (16 documents) and the binding decisions D1–D15 |
| [docs/architecture/decisions/](docs/architecture/decisions/0015-runtime-independence.md) | decision records; 0015 is the runtime and the licences |
| [docs/internals/](docs/internals/) | per-subsystem notes, written by the phase that built the subsystem |
| [docs/language/](docs/language/) | measured specifications: precedence, behavioural probes, the object and graphics ABIs |
| [toolchains/README.md](toolchains/README.md) | what a packaged toolchain holds and how it is built |
| [lib/rt/README.md](lib/rt/README.md) · [lib/gfx/README.md](lib/gfx/README.md) | the runtime and the graphics library |
| [wiki/](wiki/Home.md) | the language: the FreeBASIC manual plus the FBC-Modern extensions |

## Known limitations

- **Graphics links on `win64-msvc` only.** libtkogfx is built for the Microsoft ABI and nothing
  else.
- **Interoperating with fbc-built objects is proven on `-target win64` only.** An existing
  MinGW-built `.a` may not link against `win64-msvc`.
- **On `win64-msvc`:**
  - A program calling crt's POSIX names (`mkdir`, `rmdir`, and so on) does not link, because
    `oldnames.lib` is not in the link.
  - Where Visual Studio is installed, clang takes its library paths ahead of tiko's.
- **Debug information** is DWARF line tables, with no variables. gdb breaks, steps and unwinds on
  both Windows targets. CodeView is deferred.
- **`THREADCALL`** warns `TKO0797` and returns 0, as FBC-Modern's does.
- **There is no `-profile`.**

## Licence

tiko-lang is its own compiler, written from scratch in FreeBASIC. It is not a copy of fbc, and it
is licensed **in parts**. [LICENSE](LICENSE) is the map, and
[decision 0015](docs/architecture/decisions/0015-runtime-independence.md) records why.

| Part | Licence |
| --- | --- |
| The compiler (`src/`, `tools/`, `build/`, and its own `tests/`) and the `tiko` binaries built from it | **GNU GPL v2 or later** ([COPYING](COPYING)) |
| tiko's documentation (`docs/`, the READMEs, and the ✨ pages in `wiki/`) | **GNU FDL 1.3 or later** |
| The runtime, **tiko-rt** (`lib/rt/`), a derivative of fbc's `libfb` | **GNU LGPL v2.1 or later, with a static-linking exception** ([lib/rt/LICENSE](lib/rt/LICENSE), [COPYING.LGPL-2.1](COPYING.LGPL-2.1)) |
| The graphics library, **libtkogfx** (`lib/gfx/`), a derivative of fbc's `gfxlib2` | **LGPL v2.1 or later, same exception** ([lib/gfx/LICENSE](lib/gfx/LICENSE)) |
| fbc's test suite, vendored in `tests/vendor/` | FreeBASIC's own terms, unmodified; `fbcunit` is LGPL v2.1+ |
| The FreeBASIC manual, reproduced in `wiki/` | **GNU FDL 1.3** ([wiki/License.md](wiki/License.md)) |

**Your programs are yours.** Both libraries extend fbc's static-linking exception to themselves,
so a program compiled by tiko and linked against them can be distributed on any terms you choose,
just as a program built with fbc can.

**The packaged toolchains carry third-party components.**

- `toolchains/tiko-*/` also redistributes fbc-modern's `inc/` headers.
- For the `win64` and `linux-x86_64` targets it ships fbc's own runtime binaries under
  `lib/<target>-fb/`: the `fbrt*.o` startup objects and `libfbgfx`. For `win64` that directory
  also holds libffi and the MinGW-w64 and gcc runtime libraries.
- All of it is unmodified.
- Each toolchain's `licences/` holds tiko's notices and FreeBASIC's. It holds no separate notice
  for the MinGW-w64, gcc or libffi archives.
- clang is **not** bundled; you install it yourself.
