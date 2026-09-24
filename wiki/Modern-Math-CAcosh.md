[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CAcosh**

# CAcosh

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The inverse hyperbolic cosine.

## Syntax

```freebasic
CAcosh( byref z as Complex ) as Complex
CAcosh( byval x as double ) as Complex
```

## Notes

- Reached through the inverse **trigonometric** functions, so it inherits the Hull–Fairgrieve–Tang conditioning rather than carrying its own copy. `acosh z = ±i·acos z`, with the sign chosen to keep the real part non-negative, which is the principal branch.
- **Cut along `(-∞, 1)`.** Between -1 and 1 on the real axis the answer is purely imaginary, and that segment is answered directly so that the real part comes out `+0` rather than the `-0` the rotation would produce.
- The `double` overload is AfxNova's `CArcCosHReal`: the real `acosh` is undefined below 1 while the complex one is not.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CToString( CAcosh( CSet( 2, 1 ) ) )      '' 1.4693517443681854+0.5073563032171445i
print CToString( CAcosh( 0.5 ) )               '' 0+1.0471975511965979i   -- purely imaginary, real part +0
print CToString( CAcosh( CSet( -2, 0.0 ) ) )   '' 1.3169578969248166+3.141592653589793i   -- above the cut
print CToString( CAcosh( CSet( -2, -0.0 ) ) )  '' 1.3169578969248166-3.141592653589793i   -- below it
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
