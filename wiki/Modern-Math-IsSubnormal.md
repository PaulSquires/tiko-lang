[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IsSubnormal**

# IsSubnormal

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
IsSubnormal( x )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

'' Below the smallest normal, where the exponent has bottomed out and
'' precision is being lost bit by bit
print IsSubnormal( MinSubnormalDouble( ) )    '' true
print IsSubnormal( 1.0 )                       '' false
print IsSubnormal( 0.0 )                       '' false -- zero is neither

'' Worth testing when a result is suspiciously small: it means the
'' computation has already lost significance
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
