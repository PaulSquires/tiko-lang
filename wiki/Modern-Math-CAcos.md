[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CAcos**

# CAcos

Returns the inverse cosine of a complex number, or of any real number.

## Syntax

```freebasic
CAcos( byref z as Complex ) as Complex
CAcos( byval x as float64 ) as Complex
```

## Notes

- **The Hull–Fairgrieve–Tang method**, transcribed from .NET's `Asin_Internal`. The textbook `-i·Log( iz + CSqrt( 1 - z² ) )` cancels catastrophically near the branch points at ±1, which is exactly where an inverse sine is most often evaluated. This does not.
- Same NaN at exactly ±1 as `CAsin`, and the same fix — that segment is answered directly.
- Same cuts as `CAsin`, and the same sign-bit correction against .NET.
- The `float64` overload is AfxNova's `CArcCosReal`.
- The imaginary part is the negation of `CAsin`'s: `CAcos( 1 + 0i )` is `0 - 0i`.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CToString( CAcos( CSet( 0.5, 0.25 ) ) )  '' 1.0691874735193958-0.2813960562452928i
print CToString( CAcos( CSet( 1, 0 ) ) )       '' 0-0i
print CToString( CAcos( 2.0 ) )                '' 0-1.3169578969248166i
print CToString( CAcos( CSet( -2, 0.0 ) ) )    '' 3.141592653589793-1.3169578969248166i
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
