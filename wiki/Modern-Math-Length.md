[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Length**

# Length

The length of a vector.

## Syntax

```freebasic
Length( byref a as Vec3 ) as single
```

## Notes

- The square root of `LengthSquared`, and the **only** part of vector arithmetic that is not exact -- the root is a BOUNDED operation, accurate to a stated ulp.
- For comparing two lengths, use `LengthSquared` and skip the root entirely.
- Overloaded for `Vec2`, `Vec3`, `Vec4` and `Quat`.

## Examples

```freebasic
#include once "fb/vector.bi"
using FB

dim as Vec3 v = type<Vec3>( 3, 4, 0 )
print Length( v )            '' 5

'' For a COMPARISON the root is wasted work
dim as Vec3 w = type<Vec3>( 1, 2, 2 )
print LengthSquared( v ) > LengthSquared( w ) '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
