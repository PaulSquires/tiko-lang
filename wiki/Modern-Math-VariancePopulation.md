[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **VariancePopulation**

# VariancePopulation

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The **population** variance, dividing by n.

## Syntax

```freebasic
VariancePopulation( a( ) as T ) as double
```

## Notes

- Use it when the array **is** the entire population rather than a sample of one.
- `Variance` is the n-1 form and is the right default for measured data.
- Always smaller than the sample variance, by a factor of (n-1)/n.

## Examples

```freebasic
#include once "fb/stats.bi"
using FB

dim as double a( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print VariancePopulation( a( ) ) '' 1.6
print Variance( a( ) )           '' 2

print VariancePopulation( a( ) ) < Variance( a( ) )   '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
