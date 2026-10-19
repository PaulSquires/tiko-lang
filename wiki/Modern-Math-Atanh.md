[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Atanh**

# Atanh

Returns the inverse hyperbolic tangent of a number between -1 and 1.

## Syntax

```freebasic
Atanh( x )
```

## Notes

- 1 and -1 give infinity; outside them the result is NaN.
- The inverse of `Tanh`.
- Overloaded on `float64` and on `float32`: a single-precision argument takes the single-precision path and does not widen.
- **BOUNDED** accuracy: correct to the platform library's stated ulp bound.

## Examples

```freebasic
#import "std/numeric"
using numeric

print Atanh( 0.5 )           '' 0.5493061443340549
print Atanh( 1.0 )           '' 1.#INF
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** The libm surface
