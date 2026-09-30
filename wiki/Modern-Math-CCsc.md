[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CCsc**

# CCsc

The cosecant — one over the sine.

## Syntax

```freebasic
CCsc( byref z as Complex ) as Complex
```

## Notes

- `CReciprocal( CSin( z ) )`.
- `CCsc( 0 )` is zero, because `CReciprocal` of zero is zero — see `CReciprocal`. The true value is infinite.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

dim as Complex z = CSet( 0.5, 0.25 )

print CToString( CCsc( z ) )         '' 1.6838612682157232-0.7549097014050444i
print CToString( CCsc( CZero( ) ) )  '' 0+0i   -- zero, following CReciprocal's rule
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
