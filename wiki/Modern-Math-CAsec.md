[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CAsec**

# CAsec

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The inverse secant.

## Syntax

```freebasic
CAsec( byref z as Complex ) as Complex
CAsec( byval x as double ) as Complex
```

## Notes

- `CAcos( CReciprocal( z ) )`, so it inherits the Hull–Fairgrieve–Tang conditioning.
- The `double` overload is AfxNova's `CArcSecReal`: the real arcsecant is undefined inside `(-1, 1)` while the complex one is not.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CToString( CAsec( CSet( 2, 1 ) ) )  '' 1.1692099351270904+0.21561241855582966i
print CToString( CAsec( 0.5 ) )           '' 0-1.3169578969248166i   -- inside the real function's hole
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
