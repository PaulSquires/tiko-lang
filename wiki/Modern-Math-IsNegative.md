[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IsNegative**

# IsNegative

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
IsNegative( x )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

print IsNegative( -1.0 )      '' true
print IsNegative( 1.0 )       '' false

'' THE SIGN BIT, not the value -- so NEGATIVE ZERO answers true where
'' `x < 0` answers false. That distinction is the whole reason this
'' exists.
print IsNegative( -0.0 )      '' true
print ( -0.0 < 0 )            '' 0 -- i.e. false: the VALUE is not below
                              '' zero, only its sign bit is set
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
