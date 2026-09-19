# Compatibility

Everything tiko-lang adds is **purely additive**. `STRING`, `ZSTRING`, `WSTRING`, `FOR`, and the existing `OPERATOR FOR`/`NEXT`/`STEP` protocol are unchanged; `each`, `in` and `defer` are not reserved words; the containers add nothing to the global namespace.

**If your program compiles with fbc 1.20.0, it compiles here** — with one stated exception.

## The one exception

A **paren-less call in statement position to a sub named `defer`**. `defer` is a contextual keyword, so `defer` still works as an identifier — a variable, a field, a type name, a sub called as `defer( x )`. The single construct that changes meaning is:

```freebasic
sub defer( byval n as long )
end sub

defer 1        '' fbc 1.20.0: a call. tiko-lang: the defer statement.
```

Write `defer( 1 )` if you have this.

## Detecting tiko-lang: `__FB_MODERN__`

*Full page: [__FB_MODERN__](Category-FB-Modern-Define) ✨*

One source tree often has to build with **both** compilers — tiko-lang on your machine, stock fbc 1.20.0 for everybody else. Every tiko-lang compiler defines the intrinsic

```freebasic
__FB_MODERN__    '' always defined, always 1
```

Stock fbc never defines it, so the usual guard is:

```freebasic
#ifdef __FB_MODERN__
	#include once "fb/array.bi"
	dim names as FB.Array(of string)
#else
	dim names(0 to 63) as string
#endif
```

It is **numeric**, so `#if __FB_MODERN__` works as well as `#ifdef`, and it composes:

```freebasic
#if defined( __FB_MODERN__ ) andalso __FB_MIN_VERSION__( 1, 20, 0 )
	'' tiko-lang, 1.20.0 or later
#endif
```

Three things it deliberately is not:

- **Not a feature test.** It says *which compiler you are on*, not which features that compiler has. Guard a specific feature on it plus the version, as above.
- **Not tied to the build label.** It is independent of `__FB_BUILD_FORK_ID__`, which records how a particular build was *tagged*; `__FB_MODERN__` records which compiler *source* produced it, and is present in every tiko-lang build regardless of fork id.
- **Not a way to test the stock path.** `#undef __FB_MODERN__` does remove the symbol, like any other define — but it only silences your own guards; the compiler still accepts every tiko-lang feature. Build with stock fbc to test that path for real.

## What is deliberately identical

- **Diagnostics.** New, specific messages exist for the new features — including the instantiation chain for an error inside a generic, and near-miss reporting that names the *missing member* rather than saying "not iterable". Diagnostics **elsewhere** are byte-identical to stock fbc.
- **Code generation and compile times** for existing code.
- **Existing headers.** `datetime.bi`, `vbcompat.bi`, `FORMAT`, `Dir`/`FileExists`/`Kill` and the rest are untouched; the new libraries ship *alongside* them. The date/time libraries meet at `FromSerial` / `Serial`, so a program migrates one function at a time.
- **Namespacing.** The string library, the containers, `chrono` and `filesystem` all live in namespace `FB` behind an `#include`. Nothing becomes a keyword, and `DateTime`, `Instant`, `WallClock`, `Array`, `Map` and the rest stay available as your own identifiers until you write `using FB`.

## How it is verified

By fbc's own test suite — 1,154,412 assertions of it, plus this project's own suites on top — across four dialects, under **both** backends, on win64 and linux-x86_64. The `-gen llvm` backend passes the same gate on both targets with the same assertion counts and the same failures as `-gen gcc`.

Figures elsewhere in this wiki that include a **win32** row predate the removal of the 32-bit x86 targets and are kept as historical records; they are labelled as such where they appear.

## Licensing

This is a modified copy of the FreeBASIC compiler, so it carries FreeBASIC's licensing **unchanged** — GPL v2-or-later for the compiler, LGPL v2.1-or-later with the static-linking exception for the runtime and the container headers. See [License](License).
