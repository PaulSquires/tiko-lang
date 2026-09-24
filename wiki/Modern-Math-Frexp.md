[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Frexp**

# Frexp

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Splits a value into a fraction in [0.5, 1) and a power of two.

## Syntax

```freebasic
Frexp( byval x as double, byref expo as long ) as double
```

## Notes

- Returns the fraction and writes the exponent through `expo`, so `fraction * 2 ^ expo` reconstructs the input **exactly**.
- The pair to `ScaleB`, which puts it back together.
- Zero gives a fraction of 0 and an exponent of 0.

## Examples

```freebasic
#include once "fb/math.bi"
using FB

dim as long e
dim as double f = Frexp( 1024.0, e )

print f                      '' 0.5
print e                      '' 11

'' It round-trips exactly through ScaleB
print ScaleB( f, e )         '' 1024
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
