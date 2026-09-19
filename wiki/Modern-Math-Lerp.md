[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Lerp**

# Lerp

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Lerp( a, b, t )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

'' Linear interpolation: t = 0 gives a, t = 1 gives b
print Lerp( 0.0, 10.0, 0.0 ) '' 0
print Lerp( 0.0, 10.0, 0.5 ) '' 5
print Lerp( 0.0, 10.0, 1.0 ) '' 10

'' t is NOT clamped, so it extrapolates outside 0..1 -- Clamp it first
'' if that is not what you want
print Lerp( 0.0, 10.0, 2.0 ) '' 20
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
