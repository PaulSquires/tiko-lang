# fbx

**A FreeBASIC-compatible compiler.** Clean-sheet frontend, LLVM backend, targeting Windows x86-64
and Linux x86-64. Written in FreeBASIC, built with [FBC-Modern](https://github.com/PaulSquires).

> **Status: Phase 5 of 12 — semantic frontend.** fbx does not compile FreeBASIC yet, and there is
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
fbx --version
fbx --help [category]
fbx --dump-source <files...>      loaded files: size, lines, encoding, content hash
fbx --dump-tokens <files...>      the token stream
fbx --dump-tokens=pp <files...>   the token stream after preprocessing
fbx --lex-only / --pp-only        run one phase and report counts; the corpus gate
fbx --parse-expr <files...>       parse each line as one expression and dump the AST
fbx --dump-ast <files...>         parse whole files and dump the syntax tree
fbx --parse-only                  parse and report counts; the corpus gate
fbx --dump-types                  the type table with sizes and alignments
fbx --dump-symbols                collect declarations and dump the symbol table
fbx --resolve                     bind references and resolve type references
fbx --dump-mangle                 print the emitted symbol name of each procedure
```

Source files are accepted as ANSI, UTF-8, UTF-16LE and UTF-16BE (with or without BOM) and
normalised to UTF-8 once at load. Diagnostics carry a stable id, a source location, a rendered
caret and colour when the output is a terminal.

Anything else reports `FBX0992: not implemented in this build` rather than exiting quietly.

## Build

Requires an FBC-Modern `fbc`. Override its location with `FBX_STAGE0`.

```bash
build/build.sh Debug --test-runner    # or build\build.bat on Windows
build/test.sh                          # build + run the suite
build/lint.sh                          # layering and style rules
build/sweep.sh                         # lex all 2,709 corpus files
```

Configurations: `Debug` (`-g -exx`), `RelWithDebInfo` (`-g`), `Release`.

## Layout

```
src/support/    arenas, string interning, UTF-8/UTF-16, terminal detection
src/diag/       the diagnostic id table, engine and renderer
src/source/     source manager: files, encodings, locations, line index
src/lexer/      token model, generated keyword vocabulary, the scanner
src/pp/         the preprocessor: includes, macros, conditionals, builtins
src/ast/        the node model: arenas, payloads, NodeId
src/parser/     precedence table, Pratt expressions, statements, the intrinsic registry
src/types/      the canonical type model and its target-injected layout
src/symbols/    symbols, scopes and declaration collection
src/driver/     option table, command line, pipeline orchestration
tools/fbx-test/ the test runner
tests/          the suite; goldens live in expected/ beside their tests
docs/plan/      the architecture and implementation plan (16 documents)
docs/internals/ per-subsystem notes, written by the phase that builds the subsystem
docs/language/  measured specifications: precedence, behavioural probes
```

## Licence

TBD before first release.
