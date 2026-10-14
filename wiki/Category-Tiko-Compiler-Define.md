[Home](Home) › [All Categories](Categories) › **__TIKO_COMPILER__**

# __TIKO_COMPILER__

tiko defines `__TIKO_COMPILER__`, always `1`:

```freebasic
#ifdef __TIKO_COMPILER__
	print "tiko"; __TIKO_COMPILER__      '' tiko prints: tiko 1
#else
	print "not tiko"                     '' another compiler prints this
#endif
```

## Guarding tiko-only code

Test it with `#ifdef` or `defined( )`, so that a compiler which does not define it takes the other branch rather than stopping:

```freebasic
#import "std/containers"
#ifdef __TIKO_COMPILER__
	dim names as containers.Array( of ustring )  '' tiko builds this
#else
	dim names(0 to 63) as string         '' another compiler builds this
#endif
```

Comparing the VALUE is not a portable guard: `#if __TIKO_COMPILER__ = 1` fails on a compiler that does not define the name.

`__FB_MIN_VERSION__` is not defined by tiko, so `#if __FB_MIN_VERSION__( 1, 20, 0 )` is an error under tiko:

```
error TKO0308: invalid expression in '#if'
```

## What tiko defines

| Define | tiko |
| --- | --- |
| `__TIKO_COMPILER__` | `1` |
| `__TKO_VERSION__` | `"0.1.0-dev"` |
| `__FB_VERSION__` | `"1.20.0"` |
| `__FB_SIGNATURE__` | `"tiko-lang"` |
| `__FB_BACKEND__` | `"llvm"` |
| `__FB_MIN_VERSION__` | not defined |

`__TIKO_COMPILER__` says **which compiler** is building; `__TKO_VERSION__` says which version of it. Neither says which features it has, so code that must build with several versions still tests more than one symbol.

tests/pp/tiko-compiler-define.test holds the define and its value.

### See also

- [Compatibility](Compatibility) — compatibility notes
- [Feature Index](Feature-Index) — the language features these guards protect
- [`__FB_VERSION__`](Fb-Version) · [`__FB_SIGNATURE__`](Fb-Signature) · [`__FB_BACKEND__`](Fb-Backend)
- [Intrinsic Defines](Category-Intrinsic-Defines) — the full list

---

**Category:** [__TIKO_COMPILER__](Category-Tiko-Compiler-Define)
**Kind:** intrinsic define
