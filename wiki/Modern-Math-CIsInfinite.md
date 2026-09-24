[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CIsInfinite**

# CIsInfinite

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

True when either component is infinite.

## Syntax

```freebasic
CIsInfinite( byref z as Complex ) as boolean
```

## Notes

- **Either** component. A complex number with one infinite part is infinite whatever the other part is — including when the other part is NaN.
- That is why `CAbs` of such a number is `Infinity( )` rather than NaN: the infinity already determines the modulus.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CIsInfinite( CInfinity( ) )                 '' true
print CIsInfinite( CSet( NegInfinity( ), 1.0 ) )  '' true
print CIsInfinite( CSet( Infinity( ), NaN( ) ) )  '' true   -- infinite, not NaN
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
