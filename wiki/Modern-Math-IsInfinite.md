[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IsInfinite**

# IsInfinite

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
IsInfinite( x )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

print IsInfinite( Infinity( ) )       '' true
print IsInfinite( NegInfinity( ) )    '' true -- either sign
print IsInfinite( NaN( ) )            '' false
print IsInfinite( 1.0 )               '' false
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
