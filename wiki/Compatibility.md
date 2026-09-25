# Compatibility

tiko aims at **the same accept/reject decision as fbc** in `-lang fb`, and **the same observable behaviour**: what a program prints, returns and does. The reference is [FBC-Modern](https://github.com/PaulSquires/fbc-modern)'s `fbc` 1.20.0, and every compatibility fact is established by compiling a probe with it and running it.

The **diagnostic text** is tiko's own. Every message has a stable `TKOnnnn` id. fbc's error numbers survive only where a program can see them, through `ERR`.

## What does not compile

Each of these is a diagnostic, not a silent difference (measured 2026-09-24 at origin/master 50c71751):

| Construct | tiko says |
| --- | --- |
| `#lang "qb"`, `"fblite"`, `"deprecated"` | `TKO0317: unsupported language mode 'qb'; tiko-lang implements "fb" only` |
| `GOSUB` | `TKO0409: 'GOSUB' is not available in the fb dialect` |
| inline `ASM` | `TKO0407: inline assembly is not supported; compile that module with fbc` |
| `-m32`, `-target win32` | `TKO0104`, `TKO0103` — x86-64 only |
| fbc's `-gen`, `-lang`, `-x`; FBC-Modern's `-cprobe`, `-cimport-split`, `-cimport-indir` | `TKO0100: unknown option` |

## Known differences

**`__FB_MODERN__` and `__FB_MIN_VERSION__` are not defined.** A guard such as `#ifdef __FB_MODERN__` therefore takes its `#else` branch under tiko, and `#if __FB_MIN_VERSION__( 1, 20, 0 )` is an error (`TKO0308`). tiko identifies itself with `__TKO_VERSION__`. See [`__FB_MODERN__`](Category-FB-Modern-Define).

**`defer` is a contextual keyword, and both compilers use one rule.** It is the keyword only when a name, a keyword other than `as`, or the end of the statement follows. A sub named `defer` is therefore CALLED by `defer( 5 )`, `defer 5` and `defer -1`. An array or a UDT named `defer` is used as one (`defer( 1 ) = 3`, `defer.field_ = 4`), in both compilers.

Where they still part, a `defer` that is the keyword has no statement to defer:
- `defer x` and `defer q + 1`: fbc gives error 10 on the deferred statement, and tiko compiles it and drops the statement.
- A bare `defer`, and `defer:`: fbc gives error 347, and tiko accepts both.

Measured 2026-09-24.

**tiko accepts some programs that fbc rejects.** Each of these compiles under tiko and stops fbc with the error shown (measured 2026-09-24 at 50c71751):

| Program | fbc |
| --- | --- |
| a `for each` with no `next` at end of file | `error 13: Expected 'NEXT'` |
| `print EOF`, with no argument (tiko prints an arbitrary number) | `error 1: Argument count mismatch` |
| `sub Run( )`, declared and called | `error 4: Duplicated definition` |

Probing the extension pages found more of the same class. Each is recorded case by case on its own page (measured 2026-09-24 at origin/master 50c71751):

- **Generics.** fbc's errors 335 and 336 are not reported, and 341 only once the generic is instantiated. 11 of fbc's 30 generics `fail-*.bas` files compile under tiko, and a runaway instantiation does not stop. See [Generics](Category-Generics).
- **Tuples.** 17 of fbc's 20 tuple error cases compile under tiko, and 6 of them drop a statement. See [Tuples](Category-Tuples).
- **DEFER.** A `defer` at module level compiles and runs, where fbc gives error 348. So does a `goto` across a `defer`. See [Defer](Category-Defer).
- **`#foreignlib`.** A `"system:"` name is not honoured, and a module compiled with `-c` loses the library at the later link. See the [tutorial](modern-Foreignlib-tutorial).
- **`pascal`.** A `pascal` procedure called through a `cdecl` pointer draws no warning, and its arguments are not reversed. See [C Header Import](Category-C-Header-Import).

**The extension libraries' own suites match.** fbc's fbcunit suites were built by both compilers and their results compared (`build/suiterun.sh`, measured 2026-09-24 at origin/master 50c71751):

| Suites | Same results as fbc |
| --- | --- |
| `chrono/` | 8 of 8 |
| `finance/` | 8 of 8 |
| `datetime/` | 3 of 3 |
| `filesystem/` | 9 of 9 |
| `math/` | 9 of 9 |
| `logging/` | 2 of 2 |
| `tui/` | 10 of 10 |
| `string/` | 36 of 42 |

In `string/`, every suite for `fb/string.bi` matches: `fbstr_extract`, `fbstr_pad`, `fbstr_search` and `fbstr_transform`. The six that differ are FreeBASIC's own string tests: `asc`, `escape`, `initialization`, `string-fixed`, `string-fixed-array` and `wchr-surrogate`. In `wstring/`, 26 of 31 match; `len`, `lineinput`, `unc`, `uniseq` and `utf8` differ. The `concurrency/` suites need `-mt`, which this harness does not pass. HANDOFF §9f built them with it and found all 13 `tui/` and `concurrency/` files printing what fbc's builds print (2026-09-21).

The run programs in the same corpus all match, including every `generics/`, `tuple/` and `com/` program (`build/runscan.sh`, 2026-09-20).

**Graphics links on `win64-msvc` only.** libtkogfx is built for that ABI alone, so a `SCREEN` program does not link for `win64` or `linux-x86_64`.

**Interoperating with fbc-built objects** is proven for `-target win64`, the ABI fbc builds for. Objects link both ways, and `build/crosslink.sh` runs that in the gate. An existing MinGW-built `.a` may not link against `win64-msvc`.

## What is the same

- **Symbol names** are byte-identical to fbc's. Tuple types included, measured 2026-09-24: `NS.Sum2( byval t as (long, long) )` is `_ZN2NS4SUM2E8FBTUPLE2IiiE` under both, and a tuple's members, a namespaced type's and a generic's implicit `operator let` and copy constructor carry fbc's own substitutions (`RKS0_`, `RKS1_`).
- **The runtime ABI** is `libfb`'s: its `FBSTRING` and `FBARRAY` layouts and every `fb_*` signature. tiko links tiko-rt, a reimplementation of that ABI in FreeBASIC.
- **The headers** are FBC-Modern's, shipped unchanged in tiko's toolchain: `datetime.bi`, `vbcompat.bi`, the `fb/` libraries and the platform bindings.
- **Namespacing.** The string library, the containers, `chrono` and `filesystem` all live in namespace `FB` behind an `#include`, so nothing becomes a keyword. `each`, `in` and `spawn` stay usable as ordinary variable names in tiko, and so does `defer` as a *variable* (measured 2026-09-24).

## How it is verified

The repository's `HANDOFF.md` carries every figure with its date. In brief:

- fbc's own test corpus is vendored (2,709 `.bas` files) and run differentially: programs, fbcunit suites and the test sources are each built by both compilers and compared.
- 2,000 generated programs print what fbc's build prints.
- tiko compiles itself to a byte-identical fixpoint on win64-msvc and linux-x86_64.

## Licensing

tiko is its own compiler, written from scratch. It is licensed in parts: GPL v2-or-later for the compiler, and LGPL v2.1-or-later with the static-linking exception for tiko-rt and libtkogfx. See [License](License).
