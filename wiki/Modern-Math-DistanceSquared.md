[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **DistanceSquared**

# DistanceSquared

Returns the squared distance between two points, the cheap way to test a range.

## Syntax

```freebasic
DistanceSquared( byref a as Vec3, byref b as Vec3 ) as float32
```

## Notes

- Exact, and the correct primitive for a range check -- compare it against the square of the radius rather than taking a root.
- `LengthSquared( b - a )`.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Vec3 a = type<Vec3>( 1, 2, 3 ), b = type<Vec3>( 4, 5, 6 )

print DistanceSquared( a, b )                 '' 27

'' The comparison a range check actually wants
dim as float32 r = 6
print DistanceSquared( a, b ) <= r * r        '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
