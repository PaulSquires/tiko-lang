[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Length**

# Length

Returns the length of a vector.

## Syntax

```freebasic
Length( byref a as Vec3 ) as float32
```

## Notes

- The square root of `LengthSquared`, and the **only** part of vector arithmetic that is not exact -- the root is a BOUNDED operation, accurate to a stated ulp.
- For comparing two lengths, use `LengthSquared` and skip the root entirely.
- Overloaded for `Vec2`, `Vec3`, `Vec4` and `Quat`.

## Examples

```freebasic
#import "std/numeric"
using numeric

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
