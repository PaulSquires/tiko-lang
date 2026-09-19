[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **EuclidDiv**

# EuclidDiv

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Integer division whose remainder is always non-negative.

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
#include once "fb/mathint.bi"
using FB

dim as long a = -7, b = 2
print EuclidDiv( a, b )      '' -4
print EuclidMod( a, b )      '' 1 -- non-negative

'' It parts company with FloorDiv when the DIVISOR is negative
dim as long c = -7, d = -2
print EuclidDiv( c, d )      '' 4
print FloorDiv( c, d )       '' 3
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
