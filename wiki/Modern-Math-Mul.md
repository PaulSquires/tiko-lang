[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Mul**

# Mul

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
#import "std/numeric"
using numeric

dim as Vec3 a = type<Vec3>( 1, 2, 3 ), b = type<Vec3>( 4, 5, 6 )

dim as Vec3 c = Mul( a, b )
print c.x & " " & c.y & " " & c.z             '' 4 10 18

'' NOT the dot product, which is a scalar
print Dot( a, b )            '' 32
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
