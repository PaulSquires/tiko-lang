[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **EuclidMod**

# EuclidMod

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
EuclidMod(-7,-3)
```

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

'' The remainder that is ALWAYS NON-NEGATIVE, whatever the signs
dim as long a = -1, b = 5
print EuclidMod( a, b )      '' 4

dim as long c = -1, d = -5
print EuclidMod( c, d )      '' 4 -- still non-negative
print FloorMod( c, d )       '' -1 -- follows the divisor's sign instead
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
