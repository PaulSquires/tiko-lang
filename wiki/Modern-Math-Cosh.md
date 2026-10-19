[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Cosh**

# Cosh

Returns the hyperbolic cosine of a number.

## Syntax

```freebasic
Cosh( x )
```

## Notes

- Never less than 1. `Acosh` is its inverse for x of 1 and above.
- Overloaded on `float64` and on `float32`: a single-precision argument takes the single-precision path and does not widen.
- **BOUNDED** accuracy: correct to the platform library's stated ulp bound.

## Examples

```freebasic
#import "std/numeric"
using numeric

print Cosh( 0.0 )            '' 1
print Cosh( 1.0 )            '' 1.543080634815244
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** The libm surface
