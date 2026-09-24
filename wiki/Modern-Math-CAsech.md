[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CAsech**

# CAsech

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The inverse hyperbolic secant.

## Syntax

```freebasic
CAsech( byref z as Complex ) as Complex
```

## Notes

- `CAcosh( CReciprocal( z ) )`.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CToString( CAsech( CSet( 2, 1 ) ) )    '' 0.21561241855582966-1.1692099351270904i
print CToString( CAsech( CSet( 0.5, 0 ) ) )  '' 1.3169578969248166-0i   -- real, since 1/0.5 is above 1
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
