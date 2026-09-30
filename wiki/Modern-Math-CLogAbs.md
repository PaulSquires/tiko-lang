[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CLogAbs**

# CLogAbs

The logarithm of the modulus, without forming the modulus.

## Syntax

```freebasic
CLogAbs( byref z as Complex ) as double
```

## Notes

- `log( CAbs( z ) )` is correct and throws away the range `CAbs` works to keep. This scales by the larger component and finishes with `Log1p`, so it survives operands whose square would overflow **and** is accurate when the modulus is near 1, where the logarithm of a ratio cancels.
- `CLog` is built on it, for the same reason.
- Zero gives `-inf`, which is `log( 0 )` and not an error.
- AfxNova's, which is GSL's.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CLogAbs( CSet( 1e300, 1e300 ) )  '' 691.1221014884936
print CLogAbs( CSet( 3, 4 ) )          '' 1.6094379124341   -- log( 5 )
print CLogAbs( CZero( ) )              '' -1.#INF
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
