[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Rotate**

# Rotate

Rotates a vector by a quaternion.

## Syntax

```freebasic
Rotate( byref q as Quat, byref v as Vec3 ) as Vec3
```

## Notes

- Assumes `q` is **normalised** -- an unnormalised quaternion scales the vector as well as turning it.
- Cheaper than building a matrix when only a few vectors are being rotated; `ToMatrix` wins when there are many.
- The identity quaternion leaves the vector alone, which is the cheapest sanity check there is.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Quat q = type<Quat>( 0, 0, 0, 1 )      '' identity
dim as Vec3 v = type<Vec3>( 1, 2, 3 )

dim as Vec3 r = Rotate( q, v )
print r.x & " " & r.y & " " & r.z             '' 1 2 3 -- unchanged

'' A rotation preserves length, which is the other cheap check
print abs( Length( r ) - Length( v ) ) < 0.0001        '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
