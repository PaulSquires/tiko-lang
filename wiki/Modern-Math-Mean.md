[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Mean**

# Mean

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The arithmetic mean of an array.

## Syntax

```freebasic
Mean( a( ) as T ) as double
```

## Notes

- Computed through the **compensated** `Sum`, so a long array of values with very different magnitudes does not drift.
- Returns a `double` whatever `T` is, because the mean of integers is not an integer.
- An empty array gives 0.

## Examples

```freebasic
#include once "fb/stats.bi"
using FB

dim as double a( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print Mean( a( ) )           '' 4

'' It goes through the compensated Sum, so magnitudes that would defeat
'' a naive loop still average correctly
dim as double b( 0 to 3 ) = { 1e16, 1.0, -1e16, 1.0 }
print Mean( b( ) )           '' 0.5
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
