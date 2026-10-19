[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **EuclidDiv**

# EuclidDiv

Divides whole numbers so that the matching EuclidMod remainder is never negative.

## Syntax

```freebasic
EuclidDiv( byval a as T, byval b as T ) as T
```

## Notes

- The third convention, paired with `EuclidMod`: the quotient is whatever makes the remainder land in `0 .. abs( b ) - 1`.
- It differs from `FloorDiv` only when the divisor is negative.
- The identity holds here too: `EuclidDiv( a, b ) * b + EuclidMod( a, b )` is `a`.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as int32 a = -7, b = 2
print EuclidDiv( a, b )      '' -4
print EuclidMod( a, b )      '' 1 -- non-negative

'' It parts company with FloorDiv when the DIVISOR is negative
dim as int32 c = -7, d = -2
print EuclidDiv( c, d )      '' 4
print FloorDiv( c, d )       '' 3
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
