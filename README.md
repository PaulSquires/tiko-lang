# tiko-lang

**A FreeBASIC-compatible compiler.** Clean-sheet frontend, LLVM backend, targeting Windows x86-64
and Linux x86-64. Written in FreeBASIC, built with [FBC-Modern](https://github.com/PaulSquires).

> **Status: Phase 5 of 12 — semantic frontend.** tiko-lang does not compile FreeBASIC yet, and there is
> no backend. It tokenises, preprocesses, **parses**, and now **resolves names and mangles
> symbols**. Over the 3,230 vendored files of fbc's own test suite it binds **695,942 references
> (92.8%)** and resolves 1.4M type references with no crashes. Its emitted symbol names are
> **byte-identical to fbc's** on the 60-case gate corpus — decision D3, checked against the object
> file fbc produces, not against documentation.
>
> Everything compatibility-related here was *measured* from fbc rather than read from a manual: the
> precedence table (484 operator pairs), the builtin type layouts (field by field), and every
> mangling rule. Several of those measurements contradicted the plan, and the plan was corrected.
> Still owed in this phase: type checking, overload resolution and constant evaluation.
> The full plan is in [`docs/plan/`](docs/plan/README.md), and every phase's exit criterion is
> written down before the phase begins.

**Picking this up cold? Start with [HANDOFF.md](HANDOFF.md)** — current state, the
open bugs with reproducers, and what to do next.

## What it will be

A production compiler for the existing FreeBASIC language — same accept/reject decisions, same
runtime behaviour, same `libfb` ABI, same name mangling — with a modern architecture underneath:
real symbol tables, a real type system, a typed IR with a verifier, an explicit ABI-lowering pass,
and Clang-grade diagnostics.

It is deliberately unoriginal where originality costs: **LLVM does code generation** and the
**existing FreeBASIC runtime does the runtime work**.

## What works today

```
tiko-lang --version
tiko-lang --help [category]
tiko-lang --dump-source <files...>      loaded files: size, lines, encoding, content hash
tiko-lang --dump-tokens <files...>      the token stream
tiko-lang --dump-tokens=pp <files...>   the token stream after preprocessing
tiko-lang --lex-only / --pp-only        run one phase and report counts; the corpus gate
tiko-lang --parse-expr <files...>       parse each line as one expression and dump the AST
tiko-lang --dump-ast <files...>         parse whole files and dump the syntax tree
tiko-lang --parse-only                  parse and report counts; the corpus gate
tiko-lang --dump-types                  the type table with sizes and alignments
tiko-lang --dump-symbols                collect declarations and dump the symbol table
tiko-lang --resolve                     bind references and resolve type references
tiko-lang --dump-mangle                 print the emitted symbol name of each procedure
```

Source files are accepted as ANSI, UTF-8, UTF-16LE and UTF-16BE (with or without BOM) and
normalised to UTF-8 once at load. Diagnostics carry a stable id, a source location, a rendered
caret and colour when the output is a terminal.

Anything else reports `TKO0992: not implemented in this build` rather than exiting quietly.

## Build

Requires an FBC-Modern `fbc`. Override its location with `TKO_STAGE0`.

```bash
build/build.sh Debug --test-runner    # or build\build.bat on Windows
build/test.sh                          # build + run the suite
build/lint.sh                          # layering and style rules
build/sweep.sh                         # lex all 2,709 corpus files
```

Configurations: `Debug` (`-g -exx`), `RelWithDebInfo` (`-g`), `Release`.

## Layout

The repository holds **three source areas** -- the compiler, the runtime library and the
graphics library -- plus the toolchains they are packaged into. Each area builds itself;
there is no top-level build.

```
src/          (1) THE COMPILER
  support/       arenas, string interning, UTF-8/UTF-16, terminal detection
  diag/          the diagnostic id table, engine and renderer
  source/        source manager: files, encodings, locations, line index
  lexer/         token model, generated keyword vocabulary, the scanner
  pp/            the preprocessor: includes, macros, conditionals, builtins
  ast/           the node model: arenas, payloads, NodeId
  parser/        precedence table, Pratt expressions, statements, intrinsics
  types/         the canonical type model and its target-injected layout
  symbols/       symbols, scopes and declaration collection
  mir/           the typed IR
  codegen/       ABI lowering, the LLVM backend, the toolchain driver
  driver/        option table, command line, pipeline orchestration

lib/rt/       (2) THE RUNTIME LIBRARY -- libfb, reimplemented in FreeBASIC
  src/           str ustr strw utf io fs dt chrono math mem thread sys init ...
  build/         its own build, gate, lint, bench and symbol scripts
  tests/         abi/ (parity against fbc's own archives), bench/, unit/
  LICENSE, PROVENANCE.md

lib/gfx/      (3) THE GRAPHICS LIBRARY -- libtkogfx, a drop-in for libfbgfx
  abi/           the runtime seam: struct mirrors, context offsets
  core/          surfaces, modes, palettes, images, events, the console hooks
  raster/        the drawing primitives
  driver/        the GDI, memory and window drivers
  tools/         the A/B tests against gfxlib2

toolchains/   the distributable Windows and Linux builds (see its README)
build/        the compiler's build, test, lint and corpus-sweep scripts
tools/        tiko-test, the generators, the corpus vendoring script
tests/        the compiler suite; goldens live in expected/ beside their tests
docs/plan/    the architecture and implementation plan (16 documents)
docs/internals/ per-subsystem notes, written by the phase that builds the subsystem
docs/language/  measured specifications: precedence, behavioural probes
```

The runtime and the graphics library were developed as separate trees (`C:\dev\tiko-rt` and
this repository's `lib/gfx`) and were consolidated here so that one clone is the whole
project. `C:\dev\tiko-rt` is now a directory junction pointing at `lib/rt`, so paths that
predate the move still resolve; it is not a second copy.

## Licence

Per area, because they do not share one:

- **`lib/rt/`** -- LGPL-2.1-or-later. It is a derivative work of `libfb`; see
  [`lib/rt/LICENSE`](lib/rt/LICENSE) and [`lib/rt/PROVENANCE.md`](lib/rt/PROVENANCE.md).
- **`lib/gfx/`** -- LGPL-2.1-or-later with the static-linking exception. It is a
  derivative work of `gfxlib2`; see [`lib/gfx/README.md`](lib/gfx/README.md). The licence
  text itself is not yet in the tree.
- **`src/`, `tools/`, `tests/`** -- TBD before first release.
