[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Cross**

# Cross

The cross product: a vector perpendicular to both inputs.

## Syntax

```freebasic
Cross( byref a as Vec3, byref b as Vec3 ) as Vec3
```

## Notes

- **Vec3 only** -- the cross product is not defined in 2 or 4 dimensions.
- **Not commutative**: `Cross( a, b )` is the negation of `Cross( b, a )`, and getting the order wrong flips a surface normal.
- Its length is the area of the parallelogram the two vectors span, so it is zero for parallel inputs.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Vec3 a = type<Vec3>( 1, 2, 3 ), b = type<Vec3>( 4, 5, 6 )

dim as Vec3 c = Cross( a, b )
print c.x & " " & c.y & " " & c.z             '' -3 6 -3

'' Perpendicular to both, by construction
print Dot( c, a )            '' 0
print Dot( c, b )            '' 0

'' NOT commutative -- the order flips the normal
dim as Vec3 d = Cross( b, a )
print d.x                    '' 3
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
