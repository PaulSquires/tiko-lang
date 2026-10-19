[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Covariance**

# Covariance

Returns the sample covariance of two arrays of the same length.

## Syntax

```freebasic
Covariance( byref x as Array( of T ), byref y as Array( of T ) ) as float64
```

## Notes

- Positive when they rise together, negative when one rises as the other falls, near zero when they are unrelated.
- **Its magnitude means nothing on its own** -- it is in the product of the two units, so it changes if you measure in metres rather than feet. `Correlation` is the normalised version.
- The sample form, dividing by n-1.
- The arrays must be the same length.

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using numeric
using containers

dim as Array( of float64 ) x = { 1.0, 2.0, 3.0, 4.0, 5.0 }
dim as Array( of float64 ) y = { 2.0, 4.0, 6.0, 8.0, 10.0 }

print Covariance( x, y ) > 0            '' -1 (true) -- they rise together

'' The magnitude is in the product of the units, so scaling y scales it
dim as Array( of float64 ) z = { 20.0, 40.0, 60.0, 80.0, 100.0 }
print Covariance( x, z ) > Covariance( x, y )      '' -1 (true)

'' Correlation is the version that does not move
print abs( Correlation( x, y ) - Correlation( x, z ) ) < 1e-12   '' -1 (true) -- to within rounding
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
