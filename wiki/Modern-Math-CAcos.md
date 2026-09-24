[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CAcos**

# CAcos

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The inverse cosine.

## Syntax

```freebasic
CAcos( byref z as Complex ) as Complex
CAcos( byval x as double ) as Complex
```

## Notes

- **The Hull–Fairgrieve–Tang method**, transcribed from .NET's `Asin_Internal`. The textbook `-i·Log( iz + CSqrt( 1 - z² ) )` cancels catastrophically near the branch points at ±1, which is exactly where an inverse sine is most often evaluated. This does not.
- Same NaN at exactly ±1 as `CAsin`, and the same fix — that segment is answered directly.
- Same cuts as `CAsin`, and the same sign-bit correction against .NET.
- The `double` overload is AfxNova's `CArcCosReal`.
- The imaginary part is the negation of `CAsin`'s: `CAcos( 1 + 0i )` is `0 - 0i`.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CToString( CAcos( CSet( 0.5, 0.25 ) ) )  '' 1.0691874735193958-0.2813960562452928i
print CToString( CAcos( CSet( 1, 0 ) ) )       '' 0-0i
print CToString( CAcos( 2.0 ) )                '' 0-1.3169578969248166i
print CToString( CAcos( CSet( -2, 0.0 ) ) )    '' 3.141592653589793-1.3169578969248166i
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
