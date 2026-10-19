[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Variance**

# Variance

Returns the sample variance of an array, dividing by n-1.

## Syntax

```freebasic
Variance( byref a as Array( of T ) ) as float64
```

## Notes

- **n-1, not n**: this is the unbiased estimator for a sample drawn from a larger population, and it is the one to use unless the array IS the whole population.
- `VariancePopulation` is the n divisor.
- Fewer than two elements give NaN, since there is nothing to vary against.

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using numeric
using containers

dim as Array( of float64 ) a = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print Variance( a )           '' 2 -- divides by n-1 = 4
print VariancePopulation( a ) '' 1.6 -- divides by n = 5

'' The difference matters most on small arrays, and vanishes on large
'' ones
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
