# What Is tiko-lang

tiko-lang is a modified copy of the [FreeBASIC](https://www.freebasic.net/) compiler that adds language features, each built on the one before it: **generics**, a **structural iterator protocol**, **`FOR EACH`**, **tuples** so a function can return more than one value, a **standard container library**, **`defer`** for scope-exit cleanup, and **lambdas** with optional capture — plus **`USTRING`**, a dynamic Unicode string type that is byte-identical on every target, **`fb/chrono.bi`**, a date/time library that replaces the VB6 serial-`double` model with ticks, durations, clocks and ISO 8601, and **`fb/filesystem.bi`**, which replaces the 1985 BASIC file surface with a path algebra, a stat record, a reentrant directory walk and whole-file I/O.

It is built on fbc **1.20.0**, and it is **purely additive**.

## Why it exists

FreeBASIC is a fast, direct, genuinely useful systems language with two long-standing gaps: there is no portable Unicode string, and there is no way to write a container that works for more than one element type without macros, `ANY PTR`, or copy-paste. Both gaps push real programs toward workarounds that lose type information — and both are fixable inside the existing language rather than beside it.

It is for **existing FreeBASIC users** who want their code to keep compiling unchanged, **systems programmers** who want typed containers without a runtime, **library authors** who have been writing the same `Vector` five times, and **compiler people** who want to see a template system implemented as parser replay rather than as a separate template language.

## The goal

> **This fork is a *provable testing ground* for the new features — so that one day they may be added to the canonical FreeBASIC code base as desired. Ultimately, the goal is for this project to cease to exist, because all of tiko-lang's features will have found their way into the core FreeBASIC compiler project.**

## Project goals, stated

1. **Close real gaps in FreeBASIC** — no portable Unicode string, and no way to write a typed container, are just two examples.
2. **Preserve compatibility absolutely.** Existing programs compile unchanged; existing diagnostics are byte-identical; `each` and `in` stay usable as identifiers.
3. **Add to the language, not beside it.** Generics are parsed by the real parser. `FOR EACH` is a desugaring with no new AST or IR node. The containers are a library with no compiler privileges.
4. **Diagnostics that name the actual problem** — the missing iterator member, the instantiation that failed, the type argument that caused it.
5. **Be honest about limits.** Every known limitation is written down, measured, and shipped in the documentation rather than discovered by users.
6. **Offer the work upstream.** This exists to be reviewed and, if the FreeBASIC team wants it, merged — not to become a fork with its own ecosystem.

> **What this project is not aiming at:** a package manager, a language server, an optimizer, or faster builds. Those are worth having; they are not what this is.

## Scope, stated plainly

This is fbc 1.20.0 with several new modern features added, and one caveat. It is **not** a rewrite, **not** a new parser, and **not** a performance project. Where a capability does not exist, the documentation says so instead of implying it.

## Targets and backends

- **Targets:** win64 and linux-x86_64. Prebuilt compilers for both are committed to the repository. **32-bit x86 targets were dropped** — `-target win32` and `-target linux-x86` are refused, and there is no `fbc32.exe`; 32-bit x86 stays reachable only for `dos` and `xbox`, which have no 64-bit form. There is **no macOS build** — that tree has never been built on darwin.
- **Backends:** `gcc` (C emission), `gas64` and `llvm` carry the work on the supported targets, and all three are first class. `gas` is fbc's 32-bit x86 backend and so is now reachable only through `dos`/`xbox`. `-gen llvm` is a complete rewrite that emits current LLVM IR and hands it to `clang -c`; it needs a system `clang` 18 or newer on `PATH` and rejects inline `ASM`/`NAKED` with a real diagnostic rather than miscompiling them.

## Where to go next

- [Quick Start](Quick-Start) — compile something.
- [Feature Index](Feature-Index) ✨ — every addition, one line each.
- [Compatibility](Compatibility) — what this means for code you already have.
- The repository: <https://github.com/PaulSquires/tiko-lang>

---

*Written by Paul Squires of [PlanetSquires](https://www.planetsquires.com). Offered for upstream discussion with the FreeBASIC team.*
