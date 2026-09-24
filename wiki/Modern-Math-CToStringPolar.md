[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CToStringPolar**

# CToStringPolar

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The text form in polar coordinates.

## Syntax

```freebasic
CToStringPolar( byref z as Complex ) as string
```

## Notes

- Modulus, then the phase inside an exponential — `r * exp(θi)`. Unambiguous and ASCII, which an angle sign would not be.
- Both numbers go through `ToString`, so both round-trip.
- AfxNova's `CStrPolar`, with the same format.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CToStringPolar( CSet( 3, 4 ) )     '' 5 * exp(0.9272952180016122i)
print CToStringPolar( CSet( -1, 0.0 ) )  '' 1 * exp(3.141592653589793i)
print CToStringPolar( COne( ) )          '' 1 * exp(0i)
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
