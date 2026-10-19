[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextAfter**

# NextAfter

Returns the next representable number after x in the direction of y.

## Syntax

```freebasic
NextAfter( x, y )
```

## Notes

- One step of the type's own spacing, so `NextAfter( 1.0, 2.0 ) - 1.0` is the double epsilon.
- `Ulp` gives the size of that step directly.
- Overloaded on `float64` and on `float32`: a single-precision argument takes the single-precision path and does not widen.

## Examples

```freebasic
#import "std/numeric"
using numeric

print NextAfter( 1.0, 2.0 ) - 1.0      '' 2.220446049250313e-016
print NextAfter( 1.0, 0.0 )            '' 0.9999999999999999
print NextAfter( 0.0, 1.0 )            '' 4.940656458412465e-324 -- the smallest double
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** The libm surface
