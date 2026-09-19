[Home](Home) › [All Categories](Categories) › **__FB_MODERN__**

# __FB_MODERN__

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang category.** Everything below is new in tiko-lang and is not part of stock FreeBASIC 1.20.0.

```freebasic
#ifdef __FB_MODERN__
	'' compiled only by tiko-lang
#endif
```

An intrinsic `#define`, **always present and always `1`** in every compiler built from the tiko-lang tree. Stock fbc — 1.20.0 and every earlier release — does not define it. That is the whole feature: one symbol whose presence answers "am I being compiled by tiko-lang?".

## Why it exists

Everything tiko-lang adds is additive, so code written for stock fbc keeps compiling here (see [Compatibility](Compatibility)). The reverse is not true: `defer`, lambdas, generics, `FOR EACH`, `USTRING` and the `FB` containers are syntax errors to a stock compiler. A source tree that must build with **both** therefore needs to ask which one it is on, and ask it in the preprocessor, before the parser reaches the code in question.

```freebasic
#ifdef __FB_MODERN__
	#include once "fb/array.bi"
	dim names as FB.Array(of string)
#else
	dim names(0 to 63) as string
#endif
```

Without it there is nothing reliable to test. `__FB_VERSION__` is `"1.20.0"` in both compilers — tiko-lang is fbc 1.20.0 plus features, not a version bump — so a version comparison cannot separate them.

## It is numeric

The value is the number `1`, not the string `"1"`, so both spellings work:

```freebasic
#ifdef __FB_MODERN__            '' presence
#if defined( __FB_MODERN__ )    '' presence, in an expression
#if __FB_MODERN__               '' value
```

and it composes with the other intrinsics:

```freebasic
#if defined( __FB_MODERN__ ) andalso __FB_MIN_VERSION__( 1, 20, 0 )
	'' tiko-lang, 1.20.0 or later
#endif
```

Note the guard order. `__FB_MIN_VERSION__` alone is true on stock fbc too; `defined( __FB_MODERN__ )` is the part that narrows it to this compiler.

## Three things it deliberately is not

**Not a feature test.** It says *which compiler* you are on, not which features that compiler has. A tree that has to work with several tiko-lang versions should test the version as well, as above — one define cannot describe a moving feature set.

**Not the build label.** [`__FB_BUILD_FORK_ID__`](Fb-Build-Fork-Id) records how a particular build was *tagged*, and defaults to `fbc-modern-development` unless the build passes `FBFORKID=`. `__FB_MODERN__` is independent of it and is present in **every** build from this tree, whatever the fork id says. Use the fork id to identify a build; use `__FB_MODERN__` to gate code.

**Not a way to test the stock path.** `#undef __FB_MODERN__` does remove the symbol, like any other define — but it only silences your own guards. The compiler still accepts every tiko-lang feature, so the `#else` branch is exercised without being *checked*. Build with a stock fbc to test that path for real.

## Availability

Present in every tiko-lang compiler and on every supported target and backend — win64 and linux-x86_64, under `-gen gcc`, `-gen gas64` and `-gen llvm`. It is unconditional: no command-line switch turns it on or off, and it does not depend on dialect, `-lang`, `-mt` or the fork id.

## Implementation

One row in the compiler's table of always-defined intrinsics, with a constant value and no callback:

```freebasic
'' src/compiler/symb-define.bas
(@"__FB_MODERN__"         , @FB_MODERN        , 0                  , NULL           ), _
```

`FB_MODERN` is `"1"` in `src/compiler/fb.bi`, beside `FB_VERSION` and `FB_SIGN`. The `0` in the flags column is what makes it numeric rather than a string — a string intrinsic such as `__FB_SIGNATURE__` carries `FB_DEFINE_FLAGS_STR` there and is emitted quoted.

## How it is verified

`src/tests/pp/intrinsic.bas` asserts both that the symbol is defined and that its value is `1`, alongside the other always-defined intrinsics. Beyond that it was checked by running the shipped compilers: win64 and linux-x86_64 both report it defined with value `1`, the numeric `#if` form and the `__FB_MIN_VERSION__` composition both work, and stock fbc 1.10.1 reports it **not** defined.

### See also

- [Compatibility](Compatibility) — what else changes, and does not change, for existing code
- [Feature Index](Feature-Index) ✨ — the features this define gates
- [`__FB_BUILD_FORK_ID__`](Fb-Build-Fork-Id) — the build label, which this is not
- [`__FB_MIN_VERSION__`](Fb-Min-Version) · [`__FB_VERSION__`](Fb-Version)
- [Intrinsic Defines](Category-Intrinsic-Defines) — the full list

---

**Category:** [__FB_MODERN__](Category-FB-Modern-Define) ✨
**Kind:** intrinsic define
