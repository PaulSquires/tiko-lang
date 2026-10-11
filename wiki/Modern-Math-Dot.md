[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Dot**

# Dot

The dot product of two vectors.

## Syntax

```freebasic
Dot( byref a as Vec3, byref b as Vec3 ) as float32
```

## Notes

- Overloaded for `Vec2`, `Vec3`, `Vec4` and `Quat`, in both the single and double families.
- **Zero means perpendicular**, positive means the vectors point the same way, negative means opposite -- which is why it is the test for which side of a plane a point is on.
- `Dot( a, a )` is `LengthSquared( a )`, and that identity is how the length is computed.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Vec3 a = type<Vec3>( 1, 2, 3 ), b = type<Vec3>( 4, 5, 6 )

print Dot( a, b )            '' 32

'' Zero means perpendicular
dim as Vec3 x = type<Vec3>( 1, 0, 0 ), y = type<Vec3>( 0, 1, 0 )
print Dot( x, y )            '' 0

'' Dot with itself is the squared length
print Dot( a, a ) = LengthSquared( a )        '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
