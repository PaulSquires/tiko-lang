[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **RadToDeg**

# RadToDeg

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Converts radians to degrees.

## Syntax

```freebasic
RadToDeg( byval x as double ) as double
```

## Notes

- The inverse of `DegToRad`, using the same full-precision constant.
- For presenting an angle, not for computing with one -- the trigonometric functions all take radians.
- Overloaded on `double` and `single`.

## Examples

```freebasic
#include once "fb/math.bi"
using FB

print RadToDeg( 3.141592653589793 )           '' 180
print RadToDeg( 1.570796326794897 )           '' 90

print DegToRad( RadToDeg( 1.0 ) )             '' 1
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
