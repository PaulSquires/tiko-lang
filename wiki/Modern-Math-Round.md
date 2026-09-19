[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Round**

# Round

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

half away from zero:  2.5 -> 3,  -2.5 -> -3

## Syntax

```freebasic
Round( x )
Round( x, digits )
```

## Notes

- half away from zero: — 2.5 -> 3, — -2.5 -> -3
- 0..17 decimal places

## Examples

```freebasic
#include once "fb/math.bi"
using FB

'' HALF AWAY FROM ZERO -- the school rule, and NOT what the CPU does
print Round( 2.5 )           '' 3
print Round( -2.5 )          '' -3
print Round( 2.4 )           '' 2

'' RoundHalfEven is the banker's rule, and is what the hardware uses by
'' default -- so the two disagree on exactly the halves
print RoundHalfEven( 2.5 )   '' 2
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
