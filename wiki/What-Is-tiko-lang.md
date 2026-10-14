# What Is tiko

**tiko is a compiled, statically typed programming language for applications and systems programming.** It is written to be read: blocks say what they close (`end function`, `next`, `end if`), keywords are words, and there is very little punctuation. It has generics, tuples, lambdas, typed errors, `defer`, channels and direct use of C headers. It compiles to native code through LLVM, with no virtual machine and no garbage collector.

tiko has its own lexer, preprocessor, parser, type checker and typed IR. It emits LLVM IR and hands that to clang to make objects and executables. `tiko-lang` is the repository; the language, its compiler (`tiko`, `tiko.exe`) and its `TKO` diagnostics are all tiko.

## What tiko is good at

The readable systems language: command-line tools, services, terminal UIs and native Windows applications, where Rust is more than the job needs and Go's garbage collector or binary size is unwelcome.

- **Readable by design.** Code reads top to bottom as prose.
- **Fast.** Native code through LLVM. The [benchmarks](https://github.com/PaulSquires/tiko-lang/blob/master/bench/README.md) give the measured numbers.
- **Small and self-contained.** A hello world is a 23 KB executable that imports only `kernel32.dll` and `ucrtbase.dll`. You don't install a runtime and you don't need Visual Studio.
- **No garbage collector.** Strings and containers free themselves at the end of their scope, and [`defer`](Category-Defer) covers everything else.
- **Concurrency in the language.** [`spawn`, typed channels and `select channel`](Category-Goroutines-and-Channels).
- **Reads C headers directly.** [`#cinclude`](Category-C-Header-Import) imports a C library's own header, so there is no binding to write.
- **Batteries included.** Containers, sorting, `Result` and `Optional`, filesystem, date and time, math, exact money types, logging and a terminal UI toolkit ship with the compiler. The [Feature Index](Feature-Index) lists them.

## What it does not do

tiko is honest about where it stops:

- **No compile-time memory safety.** Runtime checks (bounds, null pointers) are available with `-exx`, but there is no borrow checker.
- **Goroutines are not green threads.** `spawn` queues a call on a pool of operating-system threads.
- **No macOS or ARM64 target yet.**
- **No inline `ASM`.** It is refused with `TKO0407` rather than miscompiled.
- **Not every dialect.** `#lang "qb"`, `"fblite"` and `"deprecated"` are refused (`TKO0317`), and so is `GOSUB` (`TKO0409`).
- **`__FB_MIN_VERSION__`.** tiko does not define it. tiko identifies itself with `__TIKO_COMPILER__` instead. See [`__TIKO_COMPILER__`](Category-Tiko-Compiler-Define).

## Targets

| Target | |
| --- | --- |
| `windows-x86_64` | The default on Windows. Links against `ucrtbase.dll` and needs no Visual Studio. The only target with graphics. |
| `linux-x86_64` | The default on Linux. |
| `win64` | The legacy MinGW ABI. |

x86-64 is the only architecture. `-m32` and `-target win32` are refused (`TKO0104`, `TKO0103`). There is **one backend**: LLVM IR through clang. See [LLVM Backend](Category-LLVM-Backend).

## Where the syntax comes from

tiko's syntax comes from the most readable family of languages ever designed for people. The language kept that readability and replaced everything underneath it: the compiler, the type system and the runtime are tiko's own.

One consequence is useful. tiko still compiles FreeBASIC 1.20 code (`#lang "fb"`), so existing programs can move over and mix freely with tiko code. [Compatibility](Compatibility) says exactly what is the same, what differs and what is refused.

## Status

The repository's `README.md` and `HANDOFF.md` carry the measured state. Among them:

- tiko compiles itself to a byte-identical fixpoint on windows-x86_64 and linux-x86_64.

tiko is pre-1.0, and there are no binary releases yet.

## Where to go next

- [Quick Start](Quick-Start): build a toolchain and compile something.
- [Feature Index](Feature-Index): every language feature and library, one line each.
- [FAQ](tiko-lang-FAQ): the questions that come up first.
- [Compatibility](Compatibility): what this means for FreeBASIC code you already have.
- The repository: <https://github.com/PaulSquires/tiko-lang>
