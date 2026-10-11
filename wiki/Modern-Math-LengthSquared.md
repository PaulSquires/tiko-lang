[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **LengthSquared**

# LengthSquared

The squared length of a vector.

## Syntax

```freebasic
LengthSquared( byref a as Vec3 ) as float32
```

## Notes

- `Dot( a, a )`, and **exact** where `Length` is not -- no square root is involved.
- The right choice whenever the value is only being compared: ordering by squared length is the same ordering.
- Also what a normalisation divides by, after one root.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Vec3 v = type<Vec3>( 3, 4, 0 )
print LengthSquared( v )     '' 25
print Length( v )            '' 5

'' Exact, and the same ordering -- so comparisons need no root
print LengthSquared( v ) = Dot( v, v )        '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
