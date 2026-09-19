[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Mul**

# Mul

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Component-wise multiplication of two vectors.

## Syntax

```freebasic
Mul( byref a as Vec3, byref b as Vec3 ) as Vec3
```

## Notes

- The **Hadamard product**: each component times the matching one. It is not the dot product and not the cross product.
- It is spelled as a named function rather than `*` because `*` between two vectors has no single agreed meaning, and picking one silently would be a trap.
- Used for per-channel colour modulation and for non-uniform scaling.

## Examples

```freebasic
#include once "fb/vector.bi"
using FB

dim as Vec3 a = type<Vec3>( 1, 2, 3 ), b = type<Vec3>( 4, 5, 6 )

dim as Vec3 c = Mul( a, b )
print c.x & " " & c.y & " " & c.z             '' 4 10 18

'' NOT the dot product, which is a scalar
print Dot( a, b )            '' 32
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
