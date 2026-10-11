# Compatibility

This page is for FreeBASIC code you already have. tiko is a language of its own, and it still compiles FreeBASIC 1.20 (`#lang "fb"`), so existing programs can move over and mix freely with tiko code. It aims at **the same accept/reject decision as fbc** in `-lang fb`, and **the same observable behaviour**: what a program prints, returns and does.

The reference is the official **fbc 1.20.0**, built from FreeBASIC's master branch on 2026-08-16. Every fact below was established by compiling a probe with that fbc and with tiko, and comparing the results. Unless a line carries another date, it was measured on **2026-09-30** with tiko built from the tip of master (`0ccdb52e`). A probe beats a reading: where the two disagree, the probe wins.

The **diagnostic text** is tiko's own. Every message has a stable `TKOnnnn` id. fbc's error numbers survive only where a program can see them, through `ERR`.

**What fbc 1.20 does not have is not a compatibility difference.** Generics, tuples, collection initializers, `defer`, lambdas, `ustring`, the fixed-width type names, `spawn` and channels, `#cinclude` and `#import` are tiko's own. Code that uses them does not compile under fbc 1.20. `dim a as int8` is fbc error 14, and `defer x` is error 42. The [Feature Index](Feature-Index) lists them. This page is about the code that both compilers accept, or one of them should.

## What does not compile under tiko

Each of these is a diagnostic, not a silent difference:

| Construct | fbc 1.20 | tiko |
| --- | --- | --- |
| `#lang "qb"`, `"fblite"`, `"deprecated"` | accepted | `TKO0317: unsupported language mode 'qb'; tiko-lang implements "fb" only` |
| `GOSUB` | error 146 in `-lang fb` (it is valid only in `fblite` and `qb`) | `TKO0409: 'GOSUB' is not available in the fb dialect` |
| inline `ASM` | compiles | `TKO0407: inline assembly is not supported; compile that module with fbc` |
| `-lang`, `-gen`, `-x` | accepted | `TKO0100: unknown option` |
| `-m32`, `-target win32` | | `TKO0104`, `TKO0103`: x86-64 only |

`GOSUB` is the one row where the two compilers agree in `-lang fb`: both refuse it. Code that asks for another dialect is what tiko refuses.

## Where tiko differs

**tiko defines `__TIKO_COMPILER__`, always `1`,** and fbc does not, so `#ifdef __TIKO_COMPILER__` is how a source tree asks "is this tiko?". `__TKO_VERSION__` gives tiko's version (`0.1.0-dev`), and fbc has no such name. See [`__TIKO_COMPILER__`](Category-Tiko-Compiler-Define).

**tiko declares ten fixed-width type names that fbc does not have:** `int8`, `uint8`, `int16`, `uint16`, `int32`, `uint32`, `int64`, `uint64`, `float32` and `float64`, typedefs for `byte` through `double`. They are not keywords. A program's own declaration of one of the names replaces tiko's with no diagnostic, so code that already uses them compiles and prints the same under both compilers: `win/basetsd.bi`'s `type INT32 as long`, a `type uint8 as integer`, a variable called `float32`. See [Fixed-Width Types](Category-Fixed-Width-Types).

**`defer` is a contextual keyword in tiko and an ordinary name in fbc 1.20.** It is the keyword only when a name, a keyword other than `as`, or the end of the statement follows. Everywhere else it stays usable as an identifier, and both compilers agree: a sub named `defer` is CALLED by `defer( 5 )`, `defer 5` and `defer -1`, and an array or a UDT named `defer` is used as one (`defer( 1 ) = 3`, `defer.field_ = 4`). Where the keyword applies, fbc 1.20 has no such statement:
- `defer print "out"` runs at the end of the scope under tiko. fbc says error 42, "Variable not declared".
- `defer x` is `TKO0874` under tiko, and a bare `defer` is `TKO0828`. fbc says error 42 for both.
- `defer q + 1` compiles under tiko with no diagnostic.
- `defer:` is a label in both compilers.

**A `"""` that ends its line opens a [block string](Category-Block-Strings) in tiko.** In fbc it is a string missing its closing quote: warning 12, and the value is one `"`. tiko reads every line up to one that starts with `"""` as the string's text instead, or reports `TKO0207` when none follows. This is the only spelling whose meaning changed: `"""abc"""` is still the five-character `"abc"` and `""""` is still one quote, in both compilers. No line of the vendored fbc suite (2,750 files), `pkg/` or `tests/` has a `"""` ending it.

**tiko accepts some programs that fbc rejects.** What was confirmed:

| Program | fbc 1.20 | tiko |
| --- | --- | --- |
| `#define run 5` -- a name fbc's runtime predeclares | `error 4: Duplicated definition` | accepted: `print run` prints 5 |

**A virtual call's object is evaluated once.** fbc evaluates the object expression of a VIRTUAL method call TWICE: `getP( )->VM( )` calls `getP` twice (probed: 2 calls). tiko evaluates it once (1 call). A program whose object expression has a side effect prints differently.

**The same on both sides.** `print len`, `print asc`, `print abs` with no operand are refused by both (fbc error 6, tiko `TKO0872`), and so are `print len( )`, `print sqr( )`, `print chr( )` (fbc error 9, tiko `TKO0801`). A `pascal` procedure gets its arguments in the same order from both compilers. A suspicious pointer assignment (`byte ptr` from `integer ptr`) draws fbc's warning 4 and tiko's `TKO0830` on the same line.

**Graphics links on `win64-msvc` only.** libtkogfx is built for that ABI alone. A `SCREEN` program links for `win64-msvc`, and for `win64` the link stops with an undefined `fb_GfxScreen`.

## Working with fbc-built code

**Interoperating with fbc-built objects** is proven for `-target win64`, the ABI fbc builds for. `build/crosslink.sh` compiles one function of each shape that can disagree (an integer, a double, and a string descriptor) with each compiler and links them in both directions. Against fbc 1.20 all 3 cases pass: an fbc object linked into a tiko program, a tiko object into an fbc program, and both halves in one program. An existing MinGW-built `.a` may not link against `win64-msvc`.

## What is the same

- **Symbol names** are byte-identical to fbc's. A probe with a namespaced procedure, overloads, a UDT with two constructors, a destructor, a method taking a string, a property, an `operator let`, a static function, virtual methods, a free function with `zstring ptr` and `wstring ptr` parameters, and a global operator exports 13 external symbols under fbc. tiko exports the same 13 under the same names, among them `_ZN2NS2PT4MOVEEiR8FBSTRING`, `_ZN2NS3SUMEii`, `_ZN2NS3SUMEdd`, `_ZN2NS3SUMEPNS_2PTERi` and `_ZplRN2NS2PTES1_`. tiko also exports three implicit members that fbc keeps file-local: the default constructors of a polymorphic base and of a type derived from it (`_ZN4ROOTC1Ev`, `_ZN3KIDC1Ev`), and the base's implicit `operator let` (`_ZN4ROOTaSERKS_`). A global in a namespace is file-local in both.
- **The runtime ABI** is `libfb`'s: its `FBSTRING` descriptor and the calling convention of its `fb_*` functions. tiko links tiko-rt, a reimplementation of that ABI in FreeBASIC. The cross-link test above exercises the string descriptor.
- **The headers** are the ones fbc ships. Of the 1,698 files in fbc 1.20's `inc/`, 1,685 are identical in tiko's toolchain (ignoring line endings). 13 differ: `crt/locale.bi`, `crt/win32/stdio.bi`, `fbc-int/string.bi`, and `win/_mingw.bi`, `commctrl.bi`, `excpt.bi`, `richedit.bi`, `secext.bi`, `shtypes.bi`, `wincrypt.bi`, `windef.bi`, `winioctl.bi` and `winuser.bi`. The toolchain adds about 2,500 files of its own, among them AfxNova; the standard library ships beside `inc/` as modules, in `pkg/std/`.
- **Namespacing.** The standard libraries are modules behind an `#import`, so nothing becomes a keyword. `each`, `in` and `spawn` stay usable as ordinary variable names in tiko, and so does `defer` as a *variable*: one program that declares all four and prints them prints `1 2 3 4` under both compilers.

## Earlier measurements

These figures were taken on earlier dates, against **FBC-Modern's** `fbc` (a superset of fbc 1.20), and were **not** re-run against fbc 1.20, except where a line says it was re-run. They are kept because they describe real work, but they are not claims about fbc 1.20.

- **The extension libraries' own suites** (the `fb/` libraries that only FBC-Modern has): fbc's fbcunit suites were built by both compilers and their results compared with `build/suiterun.sh` (2026-09-24). `chrono/` 8 of 8, `finance/` 8 of 8, `datetime/` 3 of 3, `filesystem/` 9 of 9, `math/` 9 of 9, `logging/` 2 of 2, `tui/` 10 of 10, and `string/` 36 of 42. The six `string/` suites that differ are FreeBASIC's own string tests: `asc`, `escape`, `initialization`, `string-fixed`, `string-fixed-array` and `wchr-surrogate`. `wstring/` was 26 of 31.
- **The run programs in the same corpus** all matched, including every `generics/`, `tuple/` and `com/` program (`build/runscan.sh`, 2026-09-20).
- **Warning 4, "Suspicious pointer assignment"** was compared across 781 of fbc's own programs that write pointers (2026-09-25). tiko warned on exactly fbc's lines in 774, and in the other 7 it missed some of fbc's warnings but never added one.
- **Generics and tuples** (re-run 2026-09-30). fbc 1.20 has neither, so the comparison is against FBC-Modern's own failure tests: tiko rejects all 30 generics `fail-*.bas` files, and it still compiles 3 of the 20 tuple error cases, which FBC-Modern rejects (`SIZEOF` and `TYPEOF` of a tuple type, and a nested tuple literal). See [Generics](Category-Generics) and [Tuples](Category-Tuples).

## How it is verified

- fbc's own test corpus is vendored (2,709 `.bas` files, re-counted 2026-09-30) and run differentially: programs, fbcunit suites and the test sources are each built by both compilers and compared.
- 2,000 generated programs print what fbc's build prints (measured earlier against FBC-Modern's fbc, not re-run).
- tiko compiles itself to a byte-identical fixpoint on win64-msvc and linux-x86_64 (2026-09-21, not re-run).

## Licensing

tiko is its own compiler, written from scratch. It is licensed in parts: GPL v2-or-later for the compiler, and LGPL v2.1-or-later with the static-linking exception for tiko-rt and libtkogfx. See [License](License).
