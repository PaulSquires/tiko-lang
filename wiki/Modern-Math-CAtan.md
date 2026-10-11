[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CAtan**

# CAtan

The inverse tangent.

## Syntax

```freebasic
CAtan( byref z as Complex ) as Complex
```

## Notes

- The logarithmic form, `(i/2)·( Log( 1 - iz ) - Log( 1 + iz ) )`, which is well conditioned — the cancellation that ruins the naive arcsine does not arise for the arctangent.
- **The cuts are on the imaginary axis beyond ±i, and the log form cannot see which side of one it is on**: forming `1 + iz` adds `+0.0` to `-0.0`, and IEEE resolves that to `+0.0`, destroying the sign bit that decides. So that segment is answered directly.
- **The whole imaginary axis is, in fact**, and not only for the sign: the log form cancels for a small argument and gave `atan( 1e-8·i )` as `9.999999994736e-9` for an answer that is `1e-8`.
- `CAtan( 0 )` is exactly zero.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CToString( CAtan( CSet( 0.5, 0.25 ) ) )  '' 0.4842544903299662+0.2005866181312343i
print CToString( CAtan( CSet( 0, 2 ) ) )       '' 1.5707963267948966+0.5493061443340549i   -- on the cut, above it
print CToString( CAtan( CSet( -0.0, 2 ) ) )    '' -1.5707963267948966+0.5493061443340549i   -- below it
print CImag( CAtan( CSet( 0, 1e-8 ) ) )        '' 1e-008   -- exactly 1e-8, where the log form cancels
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
