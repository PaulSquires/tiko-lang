# Building and Shipping

Every program so far was built the same way: one command, one source file, one executable. Real
projects outgrow that. They are split into parts compiled separately, they produce libraries for
other programs, they need a Windows program with no console window or an icon, a debug build and
a fast one, and in the end a set of files that runs on someone else's machine. This chapter is
about the command line that does all of that, and about what a shipped program depends on.

## Targets

tiko builds for two targets, chosen with `-target`:

| Target | Builds | Default on |
|---|---|---|
| `win64-msvc` | a Windows x86-64 executable, linked against Microsoft's Universal C Runtime | Windows |
| `linux-x86_64` | a Linux x86-64 executable, linked against the system's C library | Linux |

The compiler turns tiko into LLVM's intermediate form and hands it to **clang**, which produces
machine code and drives the linker. tiko looks for clang in the place LLVM installs it, then on
the `PATH`; the environment variable **`TKO_CLANG`** names a particular one instead. Its
runtime library, the code behind `print`, strings and files, comes with the compiler, under its
`lib` directory; **`TKO_LIBPATH`** points it at another copy, and **`TKO_INCLUDE`** does the same
for the headers.

```tiko
{{#include ../examples/ch29/target.tiko}}
```

On Windows:

```text
{{#include ../examples/ch29/target.out}}
```

On Linux:

```text
{{#include ../examples/ch29/target.linux-x86_64.out}}
```

The predefined symbols are how a program adapts to its target: `__FB_WIN32__` and `__FB_LINUX__`
for the platform, `__FB_MSVC__` when the C runtime is Microsoft's, `__FB_BACKEND__` for the code
generator. Code inside an `#ifdef` that does not apply is never compiled, so it may call
functions that do not exist on the other platform.

## Separate compilation

```tiko
{{#include ../examples/ch29/separate/greet.tiko}}
```

```tiko
{{#include ../examples/ch29/separate/main.tiko}}
```

```text
{{#include ../examples/ch29/separate/main.out}}
```

**`tiko -c greet.tiko`** compiles without linking and writes `greet.o`, an **object file**.
**`tiko main.tiko greet.o`** compiles `main.tiko` and links the two. An object file is
recompiled only when its source changes, so a large program is rebuilt a part at a time — the
same job the module system (Chapter 14) does by itself for code split into modules.

One module owns the program's **main** code, the top level that runs as the program. By default
it is the **first file named on the command line**; `-m name` chooses another. Every other
module's top-level code becomes a **module constructor** and runs before main, which is why
`greet.tiko is set up` comes first. `tiko greet.tiko main.tiko`, with the files the other way
round, makes `greet.tiko` the main module: `main.tiko`'s lines run first and `greet.tiko is set
up` last.

```admonish danger title="Pitfall"
**With `-c`, no module is main unless `-m` says so.** Compiling every file with `-c` and linking
only object files ends in a linker error about a missing entry point — on Windows,
`lld-link: error: subsystem must be defined`. Compile the main module with `-c -m name`, or
leave it for the final command, as `main.tiko` is here.
```

## Static libraries

```tiko
{{#include ../examples/ch29/static/mathlib.tiko}}
```

```tiko
{{#include ../examples/ch29/static/use-static.tiko}}
```

```text
{{#include ../examples/ch29/static/use-static.out}}
```

**`tiko -lib mathlib.tiko`** compiles the file and packs the result into a **static library**,
`libmathlib.a`, on both targets. A program names it with `#inclib "mathlib"` (or `-l mathlib`),
without the `lib` prefix or the extension, and the linker copies in the parts the program uses.
The program then carries that code inside it, and runs with nothing more beside it.

The library's user needs a declaration of each procedure, written out as `use-static.tiko` does
or, better, kept in a header (`mathlib.ti`) that the library ships beside itself and every user
includes. The linker searched the current directory for `libmathlib.a`; `-p dir` or
`#libpath "dir"` adds others, searched first (Chapter 28).

## Shared libraries

```tiko
{{#include ../examples/ch29/shared/mathlib.tiko}}
```

```tiko
{{#include ../examples/ch29/shared/use-shared.tiko}}
```

```text
{{#include ../examples/ch29/shared/use-shared.out}}
```

**`tiko -dll mathlib.tiko`** (or `-dylib`) builds a **shared library**: one file that every
program using it loads when it starts, so it is stored once and can be replaced without
rebuilding the programs. On Windows that file is `mathlib.dll`, and beside it tiko writes
`libmathlib.dll.a`, an **import library** that tells the linker what the DLL contains. On Linux
it is `libmathlib.so`. The program links it exactly as it linked the static one, with
`#inclib "mathlib"`.

**`export`** after a procedure's declaration puts it in the library's table of exported names.
On Windows only exported procedures can be called from outside the DLL: built without `export`,
the client fails to link with `undefined symbol: GCD`. Mark every procedure that is part of the
library's interface, and nothing else.

```admonish danger title="Pitfall"
**A shared library must be found again when the program runs.** Linking only records its name.
Windows looks in the program's own directory, the system directories, the current directory and
the `PATH`. Linux looks in the system's library directories and in `LD_LIBRARY_PATH`, and a tiko
executable records no directory of its own — run from beside the library, the client still fails
with `error while loading shared libraries: libmathlib.so: cannot open shared object file`. This
chapter's listing runs it with `LD_LIBRARY_PATH=.`; a shipped program installs the library where
the system looks, or ships a script that sets the variable.
```

A variable that a C DLL exports is reached with **`extern import`**, which tells the compiler to
go through the pointer Windows fills in when the DLL loads:
`extern import MyDll_Data alias "MyDll_Data" as int32`.

```admonish warning title="Status in this version"
**`extern import` does not link on `win64-msvc`.** The compiler refers to the variable directly
rather than through the DLL's import pointer, and `lld-link` reports `undefined symbol`. fbc's
own build fails too, by a different route: it asks for the 32-bit spelling of the import name.
Export a function that returns the variable's address instead. Tracked as **T85**.
```

## Windows programs

```tiko
{{#include ../examples/ch29/gui.tiko}}
```

```text
{{#include ../examples/ch29/gui.out}}
```

A Windows executable belongs to a **subsystem**. The **console** subsystem, the default, gets a
console window when it is started from the desktop, and shares the one it was started from in a
terminal. **`-s gui`** builds for the **GUI** subsystem instead: no console appears, which is
what a program with windows of its own wants. Its `print` output goes nowhere unless something has
redirected it, as the book's test harness does here. On Linux there is no such distinction, and
`-s gui` is accepted and changes nothing.

### Resources

```text
{{#include ../examples/ch29/resources/strings.rc}}
```

```tiko
{{#include ../examples/ch29/resources/strings.tiko}}
```

```text
{{#include ../examples/ch29/resources/strings.out}}
```

A Windows executable can carry **resources** inside it: icons, version information, dialog
layouts, string tables, the manifest that asks for modern controls and high-DPI awareness. They are
written in a **resource script**, a `.rc` file, and named on the command line with the sources —
`tiko strings.tiko strings.rc`. tiko compiles it with `llvm-rc`, which comes with LLVM, and links
the result in. The program reads a string table entry back with the Windows function
`LoadStringW`; an `ICON` line gives the executable the icon Explorer shows.

## Build profiles

The same source can be built for finding bugs or for speed.

```tiko
{{#include ../examples/ch29/checked.tiko}}
```

```text
{{#include ../examples/ch29/checked.out}}
```

(The program ends with exit code 6.)

| Option | Does |
|---|---|
| `-e` | checks for runtime errors: a failed `open` stops the program with a message |
| `-exx` | `-e`, plus array bounds and null-pointer checks, and where each error happened |
| `-earray`, `-enullptr`, `-elocation` | one part of `-exx` at a time |
| `-g` | debug information for a debugger, and turns `assert` on |
| `-O0` … `-O3` | how hard the optimiser works; `-O0`, none, is the default |
| `-mt` | the thread-safe runtime, needed with threads (Chapter 22) |

A **checked build** (`-exx -g`) stops at the first bad index with its line and the bounds, as
above. Without `-exx` nothing checks the index: the program reads whatever memory lies past the
end of the array, and carries on with it. A **release build** (`-O2`, or `-O3`) leaves the checks out and lets the optimiser rearrange
the code; it runs faster, and a bug that the checks would have caught becomes a wrong
answer or a crash somewhere else. Test with the checks on, ship with them off — or, for a program
where a wrong answer costs more than speed buys, ship checked.

### Build settings in the source

```tiko
{{#include ../examples/ch29/profile.tiko}}
```

```text
{{#include ../examples/ch29/profile.out}}
```

**`#cmdline "options"`** puts compiler options in the source file, so the file alone says how it
must be built and nobody has to remember. When the compiler meets it, it starts the compilation
again with those options added. Two rules: it must come **after** any `#import` — an `#import`
below it is `TKO0362: '#import' must come before any code` — and
it counts only in the **first** source file named on the command line; anywhere else it is warning
`TKO0334` and ignored. Every listing in this book that needs an option carries it this way.
`__FB_ERR__`, `__FB_MT__` and `__FB_DEBUG__` let the code see what it was given.

## Shipping

A program built for `win64-msvc` needs only what every supported Windows already has:

```text
DLL Name: ucrtbase.dll
DLL Name: KERNEL32.dll
```

— the Universal C Runtime and the Windows kernel interface. tiko's own runtime is linked into
the executable, so there is no tiko DLL to ship: the executable, plus any DLLs and data files of
its own, is the whole program. On Linux the same program needs `libc.so.6`, `libm.so.6` and
`libtinfo.so.6`, the C library, the maths library and the terminal database, which every desktop
and server distribution installs. A program built on one Linux distribution runs on others with
the same or a newer C library — build on the oldest one to be supported.

**The runtime's licence travels with the executable**, because its code is inside. tiko's runtime
is licensed under the LGPL 2.1 with a **static-linking exception**, the same terms as FreeBASIC's
runtime: a program compiled by tiko and linked with it may be distributed under any licence its
author chooses, with no obligation to publish its source. The exception covers the runtime only.
Every other library a program links — a vendored C library, a DLL — comes with its own licence,
and that licence's conditions apply.

## What it costs

- **An executable carries the runtime parts it uses.** `target.tiko` is 24 KB on Windows and
  118 KB on Linux, built at `-O0`.
- **A static library is copied into every program that uses it**; a shared one is stored once,
  and costs a lookup when each program starts.
- **`-exx` makes array-heavy code slower**: every index is compared with both bounds, and every
  pointer with null.
- **`-O2` and `-O3` make the compiler slower** and the program faster. For a quick
  edit-and-run loop, the default `-O0` builds fastest.

## Summary

- `-target win64-msvc` (Windows' default) or `linux-x86_64`. `TKO_CLANG`, `TKO_LIBPATH` and
  `TKO_INCLUDE` point the compiler at other tools, runtimes and headers.
- `-c` compiles to an object file; the first file named is main unless `-m` says otherwise; the
  other modules' top levels run first, as constructors.
- `-lib` builds `libname.a`; `-dll` builds a DLL and `libname.dll.a`, or `libname.so`, with the
  procedures marked `export`. Link either with `#inclib` or `-l`.
- A shared library must be found at run time: beside the program on Windows, in the system's
  directories or `LD_LIBRARY_PATH` on Linux.
- `-s gui` builds a Windows program with no console; a `.rc` on the command line adds
  resources.
- `-exx` and `-g` for checked builds, `-O2`/`-O3` for release; `#cmdline` keeps the options in
  the source.
- A `win64-msvc` program needs only `ucrtbase.dll` and `KERNEL32.dll`. The runtime's licence
  lets a compiled program be distributed on any terms.

## Exercises

1. Build a static library with `Gcd` and an `Lcm` built on it, and use it to find the smallest
   number that every number from 1 to 20 divides. {solution="ex29-01"}
2. Write a program that reports, from the predefined symbols, whether it was built with error
   checking, with the thread-safe runtime, and against which C runtime. {solution="ex29-02"}
3. Write `mathlib.ti`, a header with the two declarations, and change both clients to include it
   instead of declaring the functions themselves.
4. Build `use-shared.tiko`, then delete `mathlib.dll` (or `libmathlib.so`) and run it. What does
   each platform say?
5. Add an `ICON` line to `strings.rc` with an `.ico` file of your own, and check that Explorer
   shows it for the executable.
