[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IsNaN**

# IsNaN

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
IsNaN( x )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

print IsNaN( NaN( ) )        '' true
print IsNaN( 1.0 )            '' false

'' THE ONLY CORRECT TEST. A NaN is not equal to anything, itself
'' included, so `x = x` is false and `x <> x` is the old idiom this
'' replaces -- but only this one says what it means.
dim as double n = NaN( )
print ( n = n )               '' 0 -- false, printed as an integer because
                              '' a comparison of doubles is not a BOOLEAN
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
