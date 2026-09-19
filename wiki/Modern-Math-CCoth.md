[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CCoth**

# CCoth

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The hyperbolic cotangent — one over the hyperbolic tangent.

## Syntax

```freebasic
CCoth( byref z as Complex ) as Complex
```

## Notes

- `CReciprocal( CTanh( z ) )`, so it inherits the overflow guard two steps up in `CTan`.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

dim as Complex z = CSet( 0.5, 0.25 )

print CToString( CCoth( z ) )               '' 1.7658972151170627-0.7204010922182282i
print CToString( CCoth( CSet( 750, 1 ) ) )  '' 1-0i   -- heading for 1
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
