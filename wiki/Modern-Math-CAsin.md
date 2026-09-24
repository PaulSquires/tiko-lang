[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CAsin**

# CAsin

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The inverse sine.

## Syntax

```freebasic
CAsin( byref z as Complex ) as Complex
CAsin( byval x as double ) as Complex
```

## Notes

- **The Hull–Fairgrieve–Tang method**, transcribed from .NET's `Asin_Internal`. The textbook `-i·Log( iz + CSqrt( 1 - z² ) )` cancels catastrophically near the branch points at ±1, which is exactly where an inverse sine is most often evaluated. This does not.
- **Exactly ±1 on the real axis is answered directly.** `Asin_Internal` divides by zero there — its `t` term contains `1/( s + ( x - 1 ) )` and `s` is zero — so .NET's own `Asin( 1 )` is **NaN** rather than π/2.
- **The cuts are the real axis beyond ±1, and the sign of a zero imaginary part decides the side.** .NET tests `imaginary < 0.0` here, and a negative zero is not less than zero, so .NET lands on the wrong branch for half the axis: its `Asin( 2 - 0i )` has a *positive* imaginary part where C99 gives a negative one. This tests the sign bit.
- The `double` overload exists because the **real** arcsine is undefined outside `[-1, 1]` while the complex one is not — `CAsin( 2.0 )` is a perfectly ordinary complex number. AfxNova spelled it `CArcSinReal`.
- `CSin( CAsin( z ) )` returns `z` on the principal strip.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CToString( CAsin( CSet( 0.5, 0.25 ) ) )  '' 0.5016088532755009+0.2813960562452928i
print CToString( CAsin( CSet( 1, 0 ) ) )       '' 1.5707963267948966+0i   -- PI/2 -- .NET's own Asin gives NaN here
print CToString( CAsin( 2.0 ) )                '' 1.5707963267948966+1.3169578969248166i   -- the double overload
print CToString( CAsin( CSet( 2, -0.0 ) ) )    '' 1.5707963267948966-1.3169578969248166i   -- the other side of the cut
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
