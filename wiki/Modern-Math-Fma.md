[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Fma**

# Fma

Returns x * y + z with a single rounding at the end.

## Syntax

```freebasic
Fma( byval x as float64, byval y as float64, byval z as float64 ) as float64
```

## Notes

- The product is computed to full precision and only the final sum is rounded, so the intermediate rounding of a plain `x * y + z` is not there.
- That single rounding is what makes it the building block for exact dot products, polynomial evaluation and correctly-rounded division.
- Overloaded on `float64` and `float32`; the single form does not widen.

## Examples

```freebasic
#import "std/numeric"
using numeric

print Fma( 2.0, 3.0, 4.0 )   '' 10

'' One rounding, not two -- and the difference is the whole error term.
'' 0.1 * 10 is not exactly 1, but the product ROUNDS to 1, so the plain
'' expression subtracts it away to nothing.
print Fma( 0.1, 10.0, -1.0 ) '' 5.551115123125783e-017
print 0.1 * 10.0 - 1.0       '' 0 -- the error is gone

'' Recovering that term is what makes Fma the building block for exact
'' dot products and correctly-rounded division
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
