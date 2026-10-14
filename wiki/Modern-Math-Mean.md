[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Mean**

# Mean

The arithmetic mean of an array.

## Syntax

```freebasic
Mean( a( ) as T ) as float64
```

## Notes

- Computed through the **compensated** `Sum`, so a long array of values with very different magnitudes does not drift.
- Returns a `float64` whatever `T` is, because the mean of integers is not an integer.
- An empty array gives 0.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as float64 a( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print Mean( a( ) )           '' 4

'' It goes through the compensated Sum, so magnitudes that would defeat
'' a naive loop still average correctly
dim as float64 b( 0 to 3 ) = { 1e16, 1.0, -1e16, 1.0 }
print Mean( b( ) )           '' 0.5
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
