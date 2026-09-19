[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **DegToRad**

# DegToRad

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Converts degrees to radians.

## Syntax

```freebasic
DegToRad( byval x as double ) as double
```

## Notes

- Multiplies by pi/180 using the full-precision constant, rather than a literal a caller typed from memory.
- Every trigonometric function here takes radians, so this is the conversion at the boundary with a user interface or a file format that uses degrees.
- Overloaded on `double` and `single`.

## Examples

```freebasic
#include once "fb/math.bi"
using FB

print DegToRad( 180.0 )      '' 3.141592653589793
print DegToRad( 90.0 )       '' 1.570796326794897

'' Round-trips with RadToDeg
print RadToDeg( DegToRad( 45.0 ) )            '' 45
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
