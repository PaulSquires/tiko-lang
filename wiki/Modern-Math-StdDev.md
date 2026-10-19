[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **StdDev**

# StdDev

Returns the sample standard deviation of an array, dividing by n-1.

## Syntax

```freebasic
StdDev( a( ) as T ) as float64
```

## Notes

- n-1, like `Variance`. `StdDevPopulation` is the n form.
- In the same units as the data, which is why it is reported where the variance is not.
- The final square root is the one BOUNDED operation here -- accurate to a stated ulp bound rather than exact.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as float64 a( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print StdDev( a( ) )             '' 1.414213562373095
print StdDev( a( ) ) ^ 2         '' 2 -- Variance, give or take rounding
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
