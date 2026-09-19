[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **StdDevPopulation**

# StdDevPopulation

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The **population** standard deviation: the square root of `VariancePopulation`.

## Syntax

```freebasic
StdDevPopulation( a( ) as T ) as double
```

## Notes

- The n divisor, for when the array is the whole population.
- `StdDev` is the n-1 form and the usual choice for measured data.

## Examples

```freebasic
#include once "fb/stats.bi"
using FB

dim as double a( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print StdDevPopulation( a( ) )   '' 1.264911064067352
print StdDevPopulation( a( ) ) < StdDev( a( ) )       '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
