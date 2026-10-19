[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Mean**

# Mean

Returns the average of an array, or NaN if it is empty.

## Syntax

```freebasic
Mean( byref a as Array( of T ) ) as float64
```

## Notes

- Computed through the **compensated** `Sum`, so a long array of values with very different magnitudes does not drift.
- Returns a `float64` whatever `T` is, because the mean of integers is not an integer.
- An empty array gives NaN.

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using numeric
using containers

dim as Array( of float64 ) a = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print Mean( a )           '' 4

'' It goes through the compensated Sum, so magnitudes that would defeat
'' a naive loop still average correctly
dim as Array( of float64 ) b = { 1e16, 1.0, -1e16, 1.0 }
print Mean( b )           '' 0.5
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
