[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **ISqrt**

# ISqrt

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

exact floor of the true root

## Syntax

```freebasic
ISqrt( n )
```

## Notes

- exact floor of the true root

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

'' The EXACT floor of the true square root -- integer arithmetic
'' throughout, so it cannot be off by one the way clng( sqr( n ) ) can
dim as ulongint n = 26
print ISqrt( n )             '' 5

dim as ulongint sq = 25
print ISqrt( sq )            '' 5

'' At sizes where a double runs out of significand, sqr( ) starts
'' rounding to the wrong integer; this never does
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
