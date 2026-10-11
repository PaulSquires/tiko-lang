[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Correlation**

# Correlation

The Pearson correlation coefficient: covariance normalised to [-1, 1].

## Syntax

```freebasic
Correlation( x( ) as T, y( ) as T ) as float64
```

## Notes

- **Unit-free**, which is what makes it comparable between data sets where `Covariance` is not.
- 1 is a perfect straight line rising, -1 a perfect line falling, 0 no LINEAR relationship at all.
- Zero does **not** mean independent: a perfect parabola correlates at 0.
- The arrays must be the same length.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as float64 x( 0 to 4 ) = { 1.0, 2.0, 3.0, 4.0, 5.0 }
dim as float64 y( 0 to 4 ) = { 2.0, 4.0, 6.0, 8.0, 10.0 }

print Correlation( x( ), y( ) )               '' 0.9999999999999998 --
                             '' a perfect line, to within one rounding

dim as float64 down( 0 to 4 ) = { 10.0, 8.0, 6.0, 4.0, 2.0 }
print Correlation( x( ), down( ) )            '' -0.9999999999999998
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
