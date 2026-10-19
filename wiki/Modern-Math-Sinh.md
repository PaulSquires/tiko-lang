[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Sinh**

# Sinh

Returns the hyperbolic sine of a number.

## Syntax

```freebasic
Sinh( x )
```

## Notes

- `Asinh` is its inverse.
- Overloaded on `float64` and on `float32`: a single-precision argument takes the single-precision path and does not widen.
- **BOUNDED** accuracy: correct to the platform library's stated ulp bound.

## Examples

```freebasic
#import "std/numeric"
using numeric

print Sinh( 1.0 )            '' 1.175201193643801
print Asinh( Sinh( 0.7 ) )   '' 0.6999999999999998
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** The libm surface
