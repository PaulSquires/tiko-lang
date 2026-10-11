[Home](Home) › [All Categories](Categories) › **__TIKO_COMPILER__**

# __TIKO_COMPILER__

tiko defines `__TIKO_COMPILER__`, always `1`. Stock fbc and FBC-Modern do not define it. Measured on win64-msvc on 2026-09-24, beside fbc-modern 1.20:

```freebasic
#ifdef __TIKO_COMPILER__
	print "tiko"; __TIKO_COMPILER__      '' tiko prints: tiko 1
#else
	print "not tiko"                     '' fbc prints this
#endif
```

## Guarding tiko-only code

Test it with `#ifdef` or `defined( )`, so that a compiler which does not define it takes the other branch rather than stopping:

```freebasic
#import "std/containers"
#ifdef __TIKO_COMPILER__
	dim names as containers.Array( of ustring )  '' tiko builds this
#else
	dim names(0 to 63) as string         '' fbc builds this
#endif
```

Both compilers build that file and each prints from its own branch (measured). Comparing the VALUE is not a portable guard: `#if __TIKO_COMPILER__ = 1` is fbc's error 20, "Type mismatch", because under fbc the name is not defined.

`__FB_MIN_VERSION__` is not defined by tiko, so `#if __FB_MIN_VERSION__( 1, 20, 0 )` is an error under tiko:

```
error TKO0308: invalid expression in '#if'
```

## What tiko defines

| Define | tiko | FBC-Modern |
| --- | --- | --- |
| `__TIKO_COMPILER__` | `1` | not defined |
| `__TKO_VERSION__` | `"0.1.0-dev"` | not defined |
| `__FB_VERSION__` | `"1.20.0"` | `"1.20.0"` |
| `__FB_SIGNATURE__` | `"tiko-lang"` | `"FreeBASIC 1.20.0"` |
| `__FB_BACKEND__` | `"llvm"` | the backend in use (`"gcc"` by default) |
| `__FB_MIN_VERSION__` | not defined | defined |

`__TIKO_COMPILER__` says **which compiler** is building; `__TKO_VERSION__` says which version of it. Neither says which features it has, so code that must build with several versions still tests more than one symbol.

tests/pp/tiko-compiler-define.test holds the define and its value.

### See also

- [Compatibility](Compatibility) — what else differs from fbc, and what does not
- [Feature Index](Feature-Index) — the language features these guards protect
- [`__FB_VERSION__`](Fb-Version) · [`__FB_SIGNATURE__`](Fb-Signature) · [`__FB_BACKEND__`](Fb-Backend)
- [Intrinsic Defines](Category-Intrinsic-Defines) — the full list

---

**Category:** [__TIKO_COMPILER__](Category-Tiko-Compiler-Define)
**Kind:** intrinsic define
