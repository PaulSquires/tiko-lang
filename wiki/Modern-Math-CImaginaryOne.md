[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CImaginaryOne**

# CImaginaryOne

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The imaginary unit, i.

## Syntax

```freebasic
CImaginaryOne( ) as Complex
```

## Notes

- `i² = -1` exactly — no rounding, because the four-multiply form of `*` produces `(0·0 - 1·1, 0·1 + 1·0)`.
- Multiplying by `i` is a quarter turn anticlockwise, which is why several bodies in this header rotate by hand rather than calling out to a multiply.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CToString( CImaginaryOne( ) )                     '' 0+1i
print CToString( CImaginaryOne( ) * CImaginaryOne( ) )  '' -1+0i   -- exactly -1
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
