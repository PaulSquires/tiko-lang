[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **VariancePopulation**

# VariancePopulation

The **population** variance, dividing by n.

## Syntax

```freebasic
VariancePopulation( a( ) as T ) as float64
```

## Notes

- Use it when the array **is** the entire population rather than a sample of one.
- `Variance` is the n-1 form and is the right default for measured data.
- Always smaller than the sample variance, by a factor of (n-1)/n.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as float64 a( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print VariancePopulation( a( ) ) '' 1.6
print Variance( a( ) )           '' 2

print VariancePopulation( a( ) ) < Variance( a( ) )   '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
