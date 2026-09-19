[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **FloorDiv**

# FloorDiv

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Integer division rounding **towards negative infinity**.

## Syntax

```freebasic
FloorDiv( byval a as T, byval b as T ) as T
```

## Notes

- FreeBASIC's `\` truncates towards zero, matching C: `-7 \ 2` is -3. This gives -4.
- It is the division that pairs with `FloorMod`, so that `FloorDiv( a, b ) * b + FloorMod( a, b )` is `a` for every sign combination.
- `EuclidDiv` is the third convention, whose remainder is always non-negative.

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

dim as long a = -7, b = 2

print FloorDiv( a, b )       '' -4 -- towards negative infinity
print a \ b                  '' -3 -- the built-in truncates towards zero

'' The identity that makes the pair usable
print FloorDiv( a, b ) * b + FloorMod( a, b ) '' -7
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
