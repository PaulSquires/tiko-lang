[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Variance**

# Variance

The **sample** variance, dividing by n-1.

## Syntax

```freebasic
Variance( a( ) as T ) as float64
```

## Notes

- **n-1, not n**: this is the unbiased estimator for a sample drawn from a larger population, and it is the one to use unless the array IS the whole population.
- `VariancePopulation` is the n divisor.
- One element gives 0, since there is nothing to vary against.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as float64 a( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print Variance( a( ) )           '' 2 -- divides by n-1 = 4
print VariancePopulation( a( ) ) '' 1.6 -- divides by n = 5

'' The difference matters most on small arrays, and vanishes on large
'' ones
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
