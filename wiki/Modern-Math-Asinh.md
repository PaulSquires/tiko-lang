[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Asinh**

# Asinh

Returns the inverse hyperbolic sine of a number.

## Syntax

```freebasic
Asinh( x )
```

## Notes

- Defined for every number. The inverse of `Sinh`.
- Overloaded on `float64` and on `float32`: a single-precision argument takes the single-precision path and does not widen.
- **BOUNDED** accuracy: correct to the platform library's stated ulp bound.

## Examples

```freebasic
#import "std/numeric"
using numeric

print Asinh( 1.0 )           '' 0.881373587019543
print Asinh( Sinh( 0.7 ) )   '' 0.6999999999999998
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** The libm surface
