[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CAcsch**

# CAcsch

The inverse hyperbolic cosecant.

## Syntax

```freebasic
CAcsch( byref z as Complex ) as Complex
```

## Notes

- `CAsinh( CReciprocal( z ) )`.

## Examples

```freebasic
#import "std/numeric"
using FB

print CToString( CAcsch( CSet( 2, 1 ) ) )  '' 0.396568230112329-0.18631805410781552i
print CToString( CAcsch( CSet( 1, 0 ) ) )  '' 0.8813735870195429-0i
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
