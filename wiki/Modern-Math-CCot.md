[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CCot**

# CCot

The cotangent — one over the tangent.

## Syntax

```freebasic
CCot( byref z as Complex ) as Complex
```

## Notes

- `CReciprocal( CTan( z ) )`, so it inherits `CTan`'s overflow guard.
- Approaches ∓i for a large imaginary part, which is where the guard earns itself.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Complex z = CSet( 0.5, 0.25 )

print CToString( CCot( z ) )               '' 1.432721075387994-0.8872370407840959i
print CToString( CCot( CSet( 1, 750 ) ) )  '' 0-1i   -- finite, heading for -i
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
