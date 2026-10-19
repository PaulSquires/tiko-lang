[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CopySign**

# CopySign

Returns a number's size with the sign of a second number, zero's sign included.

## Syntax

```freebasic
CopySign( x, y )
```

## Notes

- Reads the **sign bit** of `y`, so it tells -0.0 from 0.0 where `y < 0` cannot.
- Overloaded on `float64` and on `float32`: a single-precision argument takes the single-precision path and does not widen.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CopySign( 3.0, -1.0 )  '' -3
print CopySign( -2.5, 1.0 )  '' 2.5
print CopySign( 1.0, -0.0 )  '' -1 -- the sign of a negative zero
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** The libm surface
