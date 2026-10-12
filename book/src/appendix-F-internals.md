# Appendix F: Compiler Internals {#app-internals}

This appendix is a map of the compiler for readers who want to know what happens between
`tiko hello.tiko` and `hello.exe`, or who want to read the source. tiko is written in FreeBASIC —
in the language this book describes, give or take the extensions it compiles itself with — and it
lives in one repository, `tiko-lang`, with its runtime, its graphics library and this book. The
figures here were measured at the commit the book is pinned to.

## The pipeline

```text
 source ─► lexer ─► preprocessor ─► parser ─► Collect ─► Resolve ─► Check ─► late checks
                                      │                                          │
                                      AST                               typed AST + symbols
                                                                                 │
     executable ◄─ clang + lld ◄─ clang -c ◄─ LLVM IR ◄─ ABI pass ◄─ MIR ◄─ lowering
```

Each stage is a separate pass over a separate representation, and each one hands the next a
finished product: the lexer does not ask the parser anything, and the backend never sees the AST.
`-v` shows the last two steps as the commands they are:

```text
clang.exe -target x86_64-pc-windows-msvc -c "hello.exe.1.o.ll" -o "hello.exe.1.o" ...
clang.exe -target x86_64-pc-windows-msvc -fuse-ld=lld "hello.exe.1.o" -o "hello.exe" ... libfb.a ...
```

**Lexer** (`src/lexer`). Bytes to tokens, one file at a time. The keyword table, `keywords.bi`,
is the 247 words of Appendix A. A token is 16 bytes: its kind, flags (did a space precede it, did a
macro make it, was it a `:`), a source location and a payload — an interned name or an index into
the literal pool. A source file may be UTF-8, with or without a byte-order mark, or UTF-16 or UTF-32 with one;
anything else is read as plain bytes. Each file is detected on its own and converted to UTF-8
before it is lexed.

**Preprocessor** (`src/pp`). Pulls tokens from the lexer and gives the parser one stream: macros
expanded, `#include`d files spliced in, `#if` branches chosen. It is also where `#import` is
handled: the imported module's **interface** — a `.tki` file, written in tiko source — is spliced in
as a frame of its own, with the headers its public declarations need (Chapter 14).

**Parser** (`src/parser`). Recursive descent, statement by statement, into an **AST** kept in an
arena: nodes are indices, not pointers. Operator precedence comes from one table, `prectable.bi`,
the only place in the compiler that states it. Every diagnostic in this book with an id in
`TKO0400`–`TKO0599` comes from here.

**Collect, Resolve and Check** (`src/symbols`, `src/types`). Collect enters every declaration into
the symbol table. Resolve binds every name to its symbol and works out every type, instantiating
generics as it meets them. Check judges what Resolve found: conversions, overloads, arguments,
assignments. A last group of passes — visibility, abstract types, override promises, the rules
about what may be initialised how — runs once everything is known. Together they are the largest
part of the frontend, and the source of most `TKO06xx`–`TKO08xx` diagnostics.

**Lowering to MIR** (`src/mir`). MIR is tiko's one intermediate representation: functions of basic
blocks, each a list of typed instructions ending in exactly one terminator. Lowering is where
FreeBASIC's semantics are eliminated — strings and their descriptors, dynamic arrays, `print`,
`for`'s exact iteration rules, constructors and destructors, `defer`, closures, goroutine frames —
so that what comes out is plain code over plain values. A verifier checks every function before
it goes on. This is the biggest directory in the compiler.

**The ABI pass** (`src/codegen`). Rewrites each signature and call for the target's calling
convention — the Microsoft x64 convention on Windows, System V on Linux — so the IR that follows
has no implicit ABI behaviour: which structures travel in registers, which by hidden pointer, how
a function returns one. `--dump-ir` shows MIR after this pass, so what will really be passed is
visible without reading LLVM.

**LLVM IR and clang**. The emitter writes LLVM IR as text, one `.ll` file per unit, and clang
compiles it. clang is not bundled: tiko runs `C:\Program Files\LLVM\bin\clang.exe` on Windows,
`/usr/bin/clang` on Linux, or whatever `TKO_CLANG` names, and it needs clang 18 or newer. The link
goes through clang with lld, or on Linux the system linker when there is no `ld.lld`.
`-O1` to `-O3` are clang's optimisations; tiko's own optimiser is deliberately thin.

**The driver** (`src/driver`). Reads the command line, decides what is being built, builds the
modules a program imports in dependency order, and runs everything above. A module is compiled
once and **cached** — its object and its interface, keyed by its sources — so a second build that
imports `std/containers` does not compile it again. `#cmdline` restarts the driver with the new
options. `#cinclude` (Chapter 28) loads libclang the first time a program uses it, to read the C
header itself.

**Diagnostics** (`src/diag`). Every message the compiler can emit is one row in one table,
`diagids.bi`, which is what Appendix B is generated from. Nothing else may invent a message, and an
id is never reused.

### Where the code is

At the pin, in `.bas` and `.bi` files:

| Directory | Files | Lines | Holds |
|---|---:|---:|---|
| `src/support`, `src/source` | 16 | 2,053 | arenas, interning, text, files and source locations |
| `src/diag` | 9 | 1,784 | the diagnostic table and its rendering |
| `src/lexer` | 4 | 1,858 | the lexer and the keyword table |
| `src/pp` | 11 | 7,128 | the preprocessor and `#import` |
| `src/parser`, `src/ast` | 29 | 11,462 | the parser and the AST |
| `src/symbols`, `src/types` | 108 | 42,140 | Collect, Resolve, Check and the late checks; the type table |
| `src/mir` | 84 | 51,496 | MIR and lowering |
| `src/codegen` | 19 | 5,522 | the ABI pass and the LLVM IR emitter |
| `src/driver` | 38 | 8,100 | the driver, modules and linking |
| `src/cimport` | 12 | 3,333 | `#cinclude` |
| `lib/rt` | 353 | 85,953 | tiko-rt, the runtime |
| `lib/gfx` | 98 | 23,156 | libtkogfx, the graphics library |

The compiler is about 135,000 lines; with its runtime and graphics library, about 244,000. The
directories are **layered**: a module may include only modules below it, the frontend never
includes anything from MIR or the backend, and a lint pass enforces that, along with a limit of
1,500 lines per source file.

## The runtime: tiko-rt

A compiled program calls a runtime library for everything the language does that the machine does
not: strings, arrays, files, the console, errors, threads. tiko's is **tiko-rt** (`lib/rt`), and it
is a reimplementation of FreeBASIC's `libfb` **written in FreeBASIC**: 325 FreeBASIC files and eight
small C files for what FreeBASIC cannot express — atomics, the jump behind `on error`, and the
Microsoft C runtime's start-up glue.

It is **ABI-compatible with `libfb`**: the same `FBSTRING` and array descriptor layouts, the same
`fb_*` function names and signatures. That is what makes tiko's runtime errors fbc's, number for
number, and lets an object fbc compiled call into it. The toolchain ships two builds of it,
`libfb.a` and the thread-safe `libfbmt.a`, and the driver picks the second by itself when a program
creates a thread, whether or not `-mt` was given (Chapter 22). Linux adds position-independent
variants for shared libraries. tiko-rt is built with fbc-modern, not with tiko, and is licensed
LGPL-2.1-or-later with the static-linking exception: a program tiko compiles may carry any licence.

## The graphics library: libtkogfx

**libtkogfx** (`lib/gfx`) is FreeBASIC's graphics library, `libfbgfx`, reimplemented in tiko: the
same `fb_Gfx*` entry points, so it is a drop-in replacement. Its A/B tests (`lib/gfx/tools`) run
drawing primitives through both libraries and compare what they drew. It is
derived from FreeBASIC's `gfxlib2`, under the same LGPL licence and exception. It is built for
windows-x86_64 only, which is why graphics programs build on Windows only (Appendix D).

## Self-hosting

tiko compiles itself. `build/bootstrap.sh` (and `bootstrap.bat` on Windows) runs the whole cycle:

```text
stage0   fbc-modern builds tiko                    -> stage1
stage1   compiles tiko's own sources               -> stage2
stage2   compiles them again                       -> stage3
```

and asserts four things, in order: that stage1 lowers **every statement** of every module (a
statement the compiler declines would otherwise vanish from the compiler it is building); that
**stage2 and stage3 are byte-identical files**, with nothing masked, which is a reproducible link
as well as a fixpoint; that stage3 compiles a program that prints what stage0's build of it prints;
and, with `--gate`, that the test suite fails against stage2 exactly what it fails against stage1.

At the commit this book is pinned to, on Windows (windows-x86_64, `-O0`), the run takes about five
minutes: fbc-modern builds stage1 in 150 seconds; stage1 lowers every statement of all 121 of
the compiler's modules and every one verifies; stage1 builds stage2 in 99 seconds and stage2
builds stage3 in 39; stage2 and stage3 are the same 5,162,496 bytes, with the same SHA-256; and
stage3's build of a test program prints what stage0's does. The suite check (`--gate`) was not
part of that run.

```text
bootstrap: stage1  lowers every statement of all 121 modules; all verify
bootstrap: stage2  built by stage1 in 99 s, 5162496 bytes
bootstrap: stage3  built by stage2 in 39 s, 5162496 bytes
bootstrap: fixpoint  stage2 == stage3, sha256 9f1be7b969b68121...
bootstrap: stage3  builds hello.bas, and it prints what stage0's build prints
bootstrap: ok
```

A fixpoint proves the compiler reproduces itself. It proves nothing about code the compiler's own
source never uses, which is why the last check runs the suite.

## How it is tested

- **The test suite**: 1,465 tests at the pin, each a small program with its expected
  diagnostics, IR or output. A fix lands with the test that would have caught it.
- **fbc's own test corpus**, vendored in `tests/vendor/` and never edited, is the acceptance gate:
  every file's diagnostics are recorded, and a change that moves any of them is examined before it
  lands.
- **Differential probes.** Every compatibility fact in the compiler — and in this book — was
  established by compiling a program with fbc and with tiko and comparing the results. The source
  carries the measurement beside the code that depends on it, so a later change has to argue with
  it.
- **This book's listings**, compiled and run on both targets against the pinned toolchain before
  each release of the book.
