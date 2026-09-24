[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **StdDev**

# StdDev

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The **sample** standard deviation: the square root of `Variance`.

## Syntax

```freebasic
StdDev( a( ) as T ) as double
```

## Notes

- n-1, like `Variance`. `StdDevPopulation` is the n form.
- In the same units as the data, which is why it is reported where the variance is not.
- The final square root is the one BOUNDED operation here -- accurate to a stated ulp bound rather than exact.

## Examples

```freebasic
#include once "fb/stats.bi"
using FB

dim as double a( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print StdDev( a( ) )             '' 1.414213562373095
print StdDev( a( ) ) ^ 2         '' 2 -- Variance, give or take rounding
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
