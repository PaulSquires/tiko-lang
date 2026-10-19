[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Tanh**

# Tanh

Returns the hyperbolic tangent of a number, which lies between -1 and 1.

## Syntax

```freebasic
Tanh( x )
```

## Notes

- Approaches 1 quickly: `Tanh( 20.0 )` already prints as 1. `Atanh` is its inverse.
- Overloaded on `float64` and on `float32`: a single-precision argument takes the single-precision path and does not widen.
- **BOUNDED** accuracy: correct to the platform library's stated ulp bound.

## Examples

```freebasic
#import "std/numeric"
using numeric

print Tanh( 1.0 )            '' 0.7615941559557649
print Tanh( 20.0 )           '' 1
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** The libm surface
