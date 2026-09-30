[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CAcot**

# CAcot

The inverse cotangent.

## Syntax

```freebasic
CAcot( byref z as Complex ) as Complex
```

## Notes

- `CAtan( CReciprocal( z ) )`.
- `CAcot( 0 )` is zero rather than π/2, because `CReciprocal` of zero is zero — see `CReciprocal`.

## Examples

```freebasic
#import "std/numeric"
using FB

print CToString( CAcot( CSet( 2, 1 ) ) )  '' 0.39269908169872414-0.1732867951399863i
print CToString( CAcot( CZero( ) ) )      '' 0+0i   -- zero, following CReciprocal's rule
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
