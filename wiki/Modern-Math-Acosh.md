[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Acosh**

# Acosh

Returns the inverse hyperbolic cosine of a number of 1 or more.

## Syntax

```freebasic
Acosh( x )
```

## Notes

- Below 1 the result is NaN.
- The inverse of `Cosh`.
- Overloaded on `float64` and on `float32`: a single-precision argument takes the single-precision path and does not widen.
- **BOUNDED** accuracy: correct to the platform library's stated ulp bound.

## Examples

```freebasic
#import "std/numeric"
using numeric

print Acosh( 2.0 )           '' 1.316957896924817
print Acosh( 0.5 )           '' 1.#QNAN
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** The libm surface
