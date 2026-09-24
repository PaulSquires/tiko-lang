[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CSech**

# CSech

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The hyperbolic secant — one over the hyperbolic cosine.

## Syntax

```freebasic
CSech( byref z as Complex ) as Complex
```

## Notes

- `CReciprocal( CCosh( z ) )`.
- One of the six reciprocal hyperbolic functions AfxNova supplies and .NET does not.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

dim as Complex z = CSet( 0.5, 0.25 )

print CToString( CSech( z ) )         '' 0.902703693945398-0.10651712464877593i
print CToString( CSech( CZero( ) ) )  '' 1-0i   -- sech 0 = 1
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
