[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CIsZero**

# CIsZero

Returns true if both parts of a complex number are zero.

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
using numeric

print CIsZero( CZero( ) )           '' true
print CIsZero( CSet( -0.0, 0.0 ) )  '' true
print CIsZero( CSet( 0, 1e-320 ) )  '' false
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
