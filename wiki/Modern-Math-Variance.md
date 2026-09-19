[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Variance**

# Variance

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The **sample** variance, dividing by n-1.

## Syntax

```freebasic
Variance( a( ) as T ) as double
```

## Notes

- **n-1, not n**: this is the unbiased estimator for a sample drawn from a larger population, and it is the one to use unless the array IS the whole population.
- `VariancePopulation` is the n divisor.
- One element gives 0, since there is nothing to vary against.

## Examples

```freebasic
#include once "fb/stats.bi"
using FB

dim as double a( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print Variance( a( ) )           '' 2 -- divides by n-1 = 4
print VariancePopulation( a( ) ) '' 1.6 -- divides by n = 5

'' The difference matters most on small arrays, and vanishes on large
'' ones
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
