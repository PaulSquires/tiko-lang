[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CNaN**

# CNaN

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

A complex NaN — both components NaN.

## Syntax

```freebasic
CNaN( ) as Complex
```

## Notes

- **A function, not a constant**, and here there is no alternative: `const as Complex N = ( 0.0/0.0, 0.0/0.0 )` is a compile-time division by zero and does not compile. Same decision, same reason, as `NaN( )` in `fb/math.bi`.
- A NaN is not equal to itself, here as everywhere. Use `CIsNaN` to test for one, never `= CNaN( )`.
- **A number with one infinite part and one NaN part is not this.** It is *infinite* — see `CIsNaN`.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CIsNaN( CNaN( ) )     '' true
print CNaN( ) = CNaN( )     '' false   -- never true, as for any NaN
print CToString( CNaN( ) )  '' nan+nani
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
