[Home](Home) › [All Categories](Categories) › **__FB_MODERN__**

# __FB_MODERN__

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang category.** `__FB_MODERN__` is FBC-Modern's define. **tiko does not define it.** This page says what that means for code that tests it, and what tiko defines instead.

FBC-Modern defines `__FB_MODERN__` (always `1`) so that one source tree can ask "is this FBC-Modern?" and gate the extensions on the answer. Stock fbc does not define it, and **neither does tiko**. Measured on win64-msvc and linux-x86_64 on 2026-09-21, and again on win64-msvc on 2026-09-24 at origin/master 50c71751:

```freebasic
#ifdef __FB_MODERN__
	print "__FB_MODERN__ defined"
#else
	print "__FB_MODERN__ not defined"      '' tiko prints this
#endif
```

## What that means for existing code

A guard written for FBC-Modern takes its **`#else` branch under tiko**, even though tiko compiles the extensions it is guarding:

```freebasic
#ifdef __FB_MODERN__
	#include once "fb/array.bi"
	dim names as FB.Array(of string)    '' FBC-Modern builds this
#else
	dim names(0 to 63) as string        '' tiko builds this
#endif
```

Nothing reports it; the program simply builds the other branch.

`__FB_MIN_VERSION__` is not defined either, so the composed guard FBC-Modern documents is **an error** under tiko:

```
error TKO0308: invalid expression in '#if'
```

That error is reported for `#if __FB_MIN_VERSION__( 1, 20, 0 )`, whether or not it is combined with `defined( __FB_MODERN__ )`.

## What tiko defines

| Define | tiko | FBC-Modern |
| --- | --- | --- |
| `__TKO_VERSION__` | `"0.1.0-dev"` | not defined |
| `__FB_VERSION__` | `"1.20.0"` | `"1.20.0"` |
| `__FB_SIGNATURE__` | `"tiko-lang"` | `"FreeBASIC 1.20.0"` |
| `__FB_BACKEND__` | `"llvm"` | the backend in use (`"gcc"` by default) |
| `__FB_MODERN__` | not defined | `1` |
| `__FB_MIN_VERSION__` | not defined | defined |

`__TKO_VERSION__` is the one that identifies tiko. A guard that should take the extension branch under either compiler tests both, and has been measured to print the same thing under each:

```freebasic
#if defined( __TKO_VERSION__ ) orelse defined( __FB_MODERN__ )
	#include once "fb/array.bi"
	dim names as FB.Array( of string )
#else
	dim names(0 to 63) as string
#endif
```

As on FBC-Modern, a define says **which compiler** is building, not which features it has. Code that must build with several versions of either still has to test more than one symbol.

### See also

- [Compatibility](Compatibility) — what else differs from fbc, and what does not
- [Feature Index](Feature-Index) ✨ — the extensions these guards protect
- [`__FB_VERSION__`](Fb-Version) · [`__FB_SIGNATURE__`](Fb-Signature) · [`__FB_BACKEND__`](Fb-Backend)
- [Intrinsic Defines](Category-Intrinsic-Defines) — the full list

---

**Category:** [__FB_MODERN__](Category-FB-Modern-Define) ✨
**Kind:** intrinsic define
