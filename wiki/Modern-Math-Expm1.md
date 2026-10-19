[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Expm1**

# Expm1

Returns e raised to a power, minus one, accurately for powers near zero.

## Syntax

```freebasic
Expm1( x )
```

## Notes

- For a tiny `x`, `exp( x ) - 1` subtracts two nearly equal numbers and loses most of its digits. `Expm1` keeps them.
- `Log1p` is its inverse.
- Overloaded on `float64` and on `float32`: a single-precision argument takes the single-precision path and does not widen.
- **BOUNDED** accuracy: correct to the platform library's stated ulp bound.

## Examples

```freebasic
#import "std/numeric"
using numeric

print Expm1( 1e-10 )         '' 1.00000000005e-010
print exp( 1e-10 ) - 1.0     '' 1.000000082740371e-010 -- wrong in the 8th decimal place
print Expm1( 1.0 )           '' 1.718281828459045
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** The libm surface
