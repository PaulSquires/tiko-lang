[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Floor**

# Floor

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Floor( x )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

print Floor( 2.7 )           '' 2
print Floor( -2.1 )          '' -3 -- TOWARDS NEGATIVE INFINITY, not zero

'' That is the difference from Truncate, and it is the whole reason both
'' exist
print Truncate( -2.1 )       '' -2
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
