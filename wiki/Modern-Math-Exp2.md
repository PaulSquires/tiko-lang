[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Exp2**

# Exp2

Returns 2 raised to a power.

## Syntax

```freebasic
Exp2( x )
```

## Notes

- The inverse of `Log2`.
- Overloaded on `float64` and on `float32`: a single-precision argument takes the single-precision path and does not widen.
- **BOUNDED** accuracy: correct to the platform library's stated ulp bound.

## Examples

```freebasic
#import "std/numeric"
using numeric

print Exp2( 10.0 )           '' 1024
print Exp2( 0.5 )            '' 1.414213562373095
print Exp2( -1.0 )           '' 0.5
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** The libm surface
