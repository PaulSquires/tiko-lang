[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Range**

# Range

Returns the largest value in an array minus the smallest.

## Syntax

```freebasic
Range( byref a as Array( of T ) ) as float64
```

## Notes

- One pass, rather than two calls that each walk the array.
- **Extremely sensitive to outliers** -- it is defined entirely by the two most extreme values. The interquartile distance from `Percentile` is the robust alternative.
- Never negative; an empty array gives NaN.

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using numeric
using containers

dim as Array( of float64 ) a = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print Range( a )          '' 4

'' Defined entirely by the extremes, so one outlier is the whole answer
dim as Array( of float64 ) b = { 2.0, 4.0, 4.0, 4.0, 1e9 }
print Range( b ) > 1e8    '' -1 (true)

'' The robust alternative
print Percentile( b, 75.0 ) - Percentile( b, 25.0 )      '' 0
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
