[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **StdDevPopulation**

# StdDevPopulation

The **population** standard deviation: the square root of `VariancePopulation`.

## Syntax

```freebasic
StdDevPopulation( a( ) as T ) as float64
```

## Notes

- The n divisor, for when the array is the whole population.
- `StdDev` is the n-1 form and the usual choice for measured data.

## Examples

```freebasic
#import "std/numeric"
using FB

dim as float64 a( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print StdDevPopulation( a( ) )   '' 1.264911064067352
print StdDevPopulation( a( ) ) < StdDev( a( ) )       '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
