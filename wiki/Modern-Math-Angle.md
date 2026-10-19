[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Angle**

# Angle

Returns the angle between two vectors in radians, from 0 to pi.

## Syntax

```freebasic
Angle( byref a as Vec3, byref b as Vec3 ) as float32
```

## Notes

- Always in `0 .. pi` -- it is the unsigned angle, so it cannot say which way round.
- Computed through a clamped arc cosine, so a dot product that floating point pushed just past 1 does not produce a NaN.
- `RadToDeg` converts it for display.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Vec3 x = type<Vec3>( 1, 0, 0 ), y = type<Vec3>( 0, 1, 0 )

print Angle( x, y )          '' 1.570796 -- a right angle in radians

'' Clamped internally, so parallel vectors give exactly 0 rather than a
'' NaN from an arc cosine of 1.0000001
print Angle( x, x )          '' 0
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
