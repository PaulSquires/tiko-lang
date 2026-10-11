[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Range**

# Range

The spread: the largest value minus the smallest.

## Syntax

```freebasic
Range( a( ) as T ) as float64
```

## Notes

- One pass, rather than two calls that each walk the array.
- **Extremely sensitive to outliers** -- it is defined entirely by the two most extreme values. The interquartile distance from `Percentile` is the robust alternative.
- Never negative; an empty array gives 0.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as float64 a( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print Range( a( ) )          '' 4

'' Defined entirely by the extremes, so one outlier is the whole answer
dim as float64 b( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 1e9 }
print Range( b( ) ) > 1e8    '' -1 (true)

'' The robust alternative
print Percentile( b( ), 0.75 ) - Percentile( b( ), 0.25 )      '' 0
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
