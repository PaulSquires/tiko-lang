[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CCot**

# CCot

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The cotangent — one over the tangent.

## Syntax

```freebasic
CCot( byref z as Complex ) as Complex
```

## Notes

- `CReciprocal( CTan( z ) )`, so it inherits `CTan`'s overflow guard.
- Approaches ∓i for a large imaginary part, which is where the guard earns itself.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

dim as Complex z = CSet( 0.5, 0.25 )

print CToString( CCot( z ) )               '' 1.432721075387994-0.8872370407840959i
print CToString( CCot( CSet( 1, 750 ) ) )  '' 0-1i   -- finite, heading for -i
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
