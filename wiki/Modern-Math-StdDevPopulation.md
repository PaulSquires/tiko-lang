[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **StdDevPopulation**

# StdDevPopulation

Returns the population standard deviation of an array, dividing by n.

## Syntax

```freebasic
StdDevPopulation( byref a as Array( of T ) ) as float64
```

## Notes

- The n divisor, for when the array is the whole population.
- `StdDev` is the n-1 form and the usual choice for measured data.

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using numeric
using containers

dim as Array( of float64 ) a = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print StdDevPopulation( a )   '' 1.264911064067352
print StdDevPopulation( a ) < StdDev( a )       '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
