[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CAtanh**

# CAtanh

The inverse hyperbolic tangent.

## Syntax

```freebasic
CAtanh( byref z as Complex ) as Complex
CAtanh( byval x as float64 ) as Complex
```

## Notes

- Reached through the inverse **trigonometric** functions, so it inherits the Hull–Fairgrieve–Tang conditioning rather than carrying its own copy. `atanh z = -i·atan( iz )`.
- **Cut along the real axis beyond ±1, and that segment cannot be reached through `CAtan`**: forming `1 + iz` adds `+0.0` to `-0.0`, IEEE gives `+0.0`, and the bit that decides the side of the cut is gone before the logarithm sees it. It is computed directly — `atanh( x ± 0i ) = atanh( 1/x ) ± iπ/2`.
- The imaginary axis is answered directly too: `atanh( ±0 + yi ) = ±0 + i·atan( y )`.
- The `float64` overload is AfxNova's `CArcTanHReal`.
- `CAtanh( ±1 )` is infinite, which is the true value.

## Examples

```freebasic
#import "std/numeric"
using FB

print CToString( CAtanh( CSet( 0.5, 0.25 ) ) )  '' 0.5003700000525311+0.3143981432077165i
print CToString( CAtanh( 2.0 ) )                '' 0.5493061443340549+1.5707963267948966i   -- outside the real function's domain
print CToString( CAtanh( CSet( 2, -0.0 ) ) )    '' 0.5493061443340549-1.5707963267948966i   -- the other side of the cut
print CToString( CAtanh( 0.5 ) )                '' 0.5493061443340549+0i   -- inside it, so simply real
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
