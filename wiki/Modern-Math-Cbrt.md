[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Cbrt**

# Cbrt

Returns the cube root of a number, negative numbers included.

## Syntax

```freebasic
Cbrt( x )
```

## Notes

- Defined for negative numbers: `Cbrt( -8.0 )` is -2. `x ^ ( 1 / 3 )` is NaN for a negative x.
- Overloaded on `float64` and on `float32`: a single-precision argument takes the single-precision path and does not widen.
- **BOUNDED** accuracy: correct to the platform library's stated ulp bound.

## Examples

```freebasic
#import "std/numeric"
using numeric

print Cbrt( 27.0 )           '' 3
print Cbrt( -8.0 )           '' -2 -- a real root for a negative number
print Cbrt( 2.0 )            '' 1.259921049894873
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** The libm surface
