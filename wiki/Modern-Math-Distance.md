[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Distance**

# Distance

The distance between two points.

## Syntax

```freebasic
Distance( byref a as Vec3, byref b as Vec3 ) as single
```

## Notes

- `Length( b - a )`, with the same one inexact square root.
- `DistanceSquared` is the exact form, and is what a proximity test should use.

## Examples

```freebasic
#include once "fb/vector.bi"
using FB

dim as Vec3 a = type<Vec3>( 1, 2, 3 ), b = type<Vec3>( 4, 5, 6 )

print Distance( a, b )       '' 5.196152 -- sqr( 27 )

'' A proximity test needs no root: compare squares
dim as single radius = 6
print DistanceSquared( a, b ) < radius * radius        '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
