[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IsNormal**

# IsNormal

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
IsNormal( x )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

print IsNormal( 1.0 )         '' true
print IsNormal( 0.0 )         '' false -- zero is not normal
print IsNormal( MinSubnormalDouble( ) )       '' false
print IsNormal( NaN( ) )      '' false

'' Normal means full precision: finite, non-zero, and not subnormal
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
