[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Percentile**

# Percentile

The value below which the given fraction of the data falls.

## Syntax

```freebasic
Percentile( a( ) as T, byval p as double ) as double
```

## Notes

- `p` is a **PERCENTAGE from 0 to 100**, not a fraction -- `Percentile( a, 50 )` is the median, and `Percentile( a, 0.5 )` is the half-of-one-percent point, which is almost the minimum.
- Out-of-range values are **clamped** to 0 and 100 rather than rejected.
- Linear interpolation between order statistics: the **R type-7 / NumPy default**. Nine definitions exist and disagree, and this one is named so a caller comparing tools knows which.
- It sorts a **copy** -- asking a question about an array does not reorder the caller's data.

## Examples

```freebasic
#include once "fb/stats.bi"
using FB

dim as double a( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print Percentile( a( ), 50.0 )   '' 4 -- the median
print Percentile( a( ), 0.0 )    '' 2 -- the minimum
print Percentile( a( ), 100.0 )  '' 6 -- the maximum
print Percentile( a( ), 95.0 )   '' 5.6 -- interpolated, not an element

'' A PERCENTAGE, not a fraction. This asks for the half-of-one-percent
'' point, which is nearly the minimum -- not the median.
print Percentile( a( ), 0.5 )    '' 2.04
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
