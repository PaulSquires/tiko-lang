[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **COne**

# COne

The complex number one.

## Syntax

```freebasic
COne( ) as Complex
```

## Notes

- A function rather than a constant — see `CZero`.
- `z * CReciprocal( z )` is `COne( )` to within rounding, which is the identity most worth asserting about a complex division.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CToString( COne( ) )                 '' 1+0i
print CToString( CSet( 3, 4 ) * COne( ) )  '' 3+4i   -- the multiplicative identity
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
