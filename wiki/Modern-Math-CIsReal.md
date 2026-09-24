[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CIsReal**

# CIsReal

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

True when the imaginary part is zero.

## Syntax

```freebasic
CIsReal( byref z as Complex ) as boolean
```

## Notes

- **True for a negative zero imaginary part.** `-0.0 = 0.0` as numbers, so `CSet( 3, -0.0 )` is on the real axis — but *which* zero it carries decides which side of a branch cut it is on. `IsNegative` from `fb/math.bi` is what tells them apart.
- A merely tiny imaginary part is not zero: `1e-320` is subnormal, not absent.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CIsReal( CSet( 3, 0 ) )       '' true
print CIsReal( CSet( 3, -0.0 ) )    '' true   -- the other zero is still zero
print CIsReal( CSet( 3, 1e-320 ) )  '' false   -- subnormal, not absent
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
