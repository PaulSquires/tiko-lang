[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CIsZero**

# CIsZero

True when both components are zero.

## Syntax

```freebasic
CIsZero( byref z as Complex ) as boolean
```

## Notes

- True for either sign of zero in either component — see `CIsReal`.
- `CReciprocal` and `CSgn` both check this first, and both return zero rather than an infinity or a NaN when it holds.

## Examples

```freebasic
#import "std/numeric"
using FB

print CIsZero( CZero( ) )           '' true
print CIsZero( CSet( -0.0, 0.0 ) )  '' true
print CIsZero( CSet( 0, 1e-320 ) )  '' false
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
