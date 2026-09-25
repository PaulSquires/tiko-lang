# What Is tiko-lang

**tiko is a FreeBASIC-compatible compiler, written from scratch in FreeBASIC.** It has its own lexer, preprocessor, parser, type checker and typed IR. It emits LLVM IR and hands that to clang to make objects and executables. tiko-lang is the repository; the compiler, its binary (`tiko`, `tiko.exe`) and its `TKO` diagnostics are all tiko.

It is not a copy or a fork of fbc. What it shares with fbc is the **language**, and it is measured against fbc rather than derived from it: every compatibility question is settled by compiling a probe with fbc and running it.

## What it compiles

`#lang "fb"` as [FBC-Modern](https://github.com/PaulSquires/fbc-modern) implements it: FreeBASIC 1.20.0, plus FBC-Modern's extensions. tiko compiles these extensions:

- generics
- the iterator protocol and `FOR EACH`
- tuples
- `defer`
- lambdas
- `USTRING`
- `spawn`, channels and `select channel`
- `#foreignlib`
- `#cinclude`, which imports a C header through libclang

It also compiles the libraries built on them, listed in the [Feature Index](Feature-Index) ✨: the containers, `chrono`, `filesystem`, and the string and math libraries.

The manual pages in this wiki describe the language. The ✨ pages describe the extensions. Where tiko's behaviour is known to differ from fbc's, the page says so; [Compatibility](Compatibility) collects those differences.

## What "compatible" means here

- **The same accept/reject decision** as fbc in `-lang fb`, and **the same observable behaviour**: what the program prints, returns and does.
- **Byte-identical symbol names.** An object tiko builds for `-target win64` links with one fbc built.
- **The same runtime ABI.** tiko links **tiko-rt**, a reimplementation of fbc's `libfb` ABI in FreeBASIC, and **libtkogfx**, a drop-in for fbc's graphics library.
- **The diagnostic text is tiko's own.** Every message has a stable `TKOnnnn` id.

## Targets

| Target | |
| --- | --- |
| `win64-msvc` | The default on Windows. Links against `ucrtbase.dll` and needs no Visual Studio. The only target with graphics. |
| `win64` | The MinGW ABI. The one that interoperates with fbc-built objects and libraries. |
| `linux-x86_64` | The default on Linux. |

x86-64 is the only architecture. `-m32` and `-target win32` are refused (`TKO0104`, `TKO0103`); 32-bit support was removed on 2026-09-04. There is no macOS target and no ARM64 target.

There is **one backend**: LLVM IR through clang. See [LLVM Backend](Category-LLVM-Backend).

## What it does not do

- **Dialects other than `fb`.** `#lang "qb"`, `"fblite"` and `"deprecated"` are refused (`TKO0317`), and so is `GOSUB` (`TKO0409`).
- **Inline `ASM`.** It is refused with `TKO0407` rather than miscompiled.
- **`__FB_MIN_VERSION__`.** tiko does not define it. tiko identifies itself with `__TIKO_COMPILER__` instead. See [`__TIKO_COMPILER__`](Category-Tiko-Compiler-Define).

## Status

The repository's `README.md` and `HANDOFF.md` carry the measured state, every figure dated. Among them:

- tiko compiles itself to a byte-identical fixpoint on win64-msvc and linux-x86_64 (2026-09-21).
- Every in-scope run program in fbc's own test corpus prints what fbc's build prints (2026-09-20).
- 495 of the 631 fbcunit suites that build under both compilers give fbc's results (2026-09-20).

## Where to go next

- [Quick Start](Quick-Start) — build a toolchain and compile something.
- [Feature Index](Feature-Index) ✨ — every extension, one line each.
- [Compatibility](Compatibility) — what this means for code you already have.
- The repository: <https://github.com/PaulSquires/tiko-lang>
