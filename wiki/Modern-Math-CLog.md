[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CLog**

# CLog

The natural logarithm, or the logarithm to a given base.

## Syntax

```freebasic
CLog( byref z as Complex ) as Complex
CLog( byref z as Complex, byval baseValue as float64 ) as Complex
```

## Notes

- **Principal branch, cut along the negative real axis, with the cut below it**: `CLog( -1 + 0i )` is `+πi` and `CLog( -1 - 0i )` is `-πi`. That is `atan2`'s convention and C99's, and it is why the two zeros have to be distinguishable.
- Built on `CLogAbs` rather than on `log( CAbs( z ) )`, so it survives operands whose square would overflow.
- The two-argument form is `CLog( z ) / log( baseValue )`. A base of 1 gives NaN, as it must.
- `CExp( CLog( z ) )` returns `z`; `CLog( CExp( z ) )` returns `z` only while the imaginary part is inside `(-π, π]`, because outside it a different branch is the principal one.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CToString( CLog( CSet( 3, 4 ) ) )       '' 1.6094379124341003+0.9272952180016122i
print CToString( CLog( CSet( -1, 0.0 ) ) )    '' 0+3.141592653589793i   -- above the cut
print CToString( CLog( CSet( -1, -0.0 ) ) )   '' 0-3.141592653589793i   -- below it
print CToString( CLog( CSet( 8, 0 ), 2.0 ) )  '' 3+0i   -- log base 2 of 8
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
