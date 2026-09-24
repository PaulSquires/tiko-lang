[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CCsch**

# CCsch

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The hyperbolic cosecant — one over the hyperbolic sine.

## Syntax

```freebasic
CCsch( byref z as Complex ) as Complex
```

## Notes

- `CReciprocal( CSinh( z ) )`.
- `CCsch( 0 )` is zero, following `CReciprocal`'s rule; the true value is infinite.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

dim as Complex z = CSet( 0.5, 0.25 )

print CToString( CCsch( z ) )         '' 1.51734688627714-0.8384070208472441i
print CToString( CCsch( CZero( ) ) )  '' 0+0i
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
