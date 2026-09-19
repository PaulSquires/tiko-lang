[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Clamp**

# Clamp

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Clamp( v, lo, hi )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

dim as double lo = 0.0, hi = 10.0

print Clamp( 5.0, lo, hi )   '' 5 -- already inside
print Clamp( -3.0, lo, hi )  '' 0 -- pulled up to the floor
print Clamp( 99.0, lo, hi )  '' 10 -- pushed down to the ceiling

'' Reads better than Max( lo, Min( hi, x ) ) and says what it is for
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
