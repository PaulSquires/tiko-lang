[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **VariancePopulation**

# VariancePopulation

Returns the population variance of an array, dividing by n.

## Syntax

```freebasic
VariancePopulation( byref a as Array( of T ) ) as float64
```

## Notes

- Use it when the array **is** the entire population rather than a sample of one.
- `Variance` is the n-1 form and is the right default for measured data.
- Always smaller than the sample variance, by a factor of (n-1)/n.

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using numeric
using containers

dim as Array( of float64 ) a = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print VariancePopulation( a ) '' 1.6
print Variance( a )           '' 2

print VariancePopulation( a ) < Variance( a )   '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
