[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CCsc**

# CCsc

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The cosecant — one over the sine.

## Syntax

```freebasic
CCsc( byref z as Complex ) as Complex
```

## Notes

- `CReciprocal( CSin( z ) )`.
- `CCsc( 0 )` is zero, because `CReciprocal` of zero is zero — see `CReciprocal`. The true value is infinite.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

dim as Complex z = CSet( 0.5, 0.25 )

print CToString( CCsc( z ) )         '' 1.6838612682157232-0.7549097014050444i
print CToString( CCsc( CZero( ) ) )  '' 0+0i   -- zero, following CReciprocal's rule
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
