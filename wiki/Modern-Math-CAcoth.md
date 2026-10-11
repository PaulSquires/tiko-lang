[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CAcoth**

# CAcoth

The inverse hyperbolic cotangent.

## Syntax

```freebasic
CAcoth( byref z as Complex ) as Complex
```

## Notes

- `CAtanh( CReciprocal( z ) )`, so it inherits the branch-cut handling of `CAtanh`.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CToString( CAcoth( CSet( 2, 1 ) ) )  '' 0.4023594781085251-0.23182380450040307i
print CToString( CAcoth( CSet( 2, 0 ) ) )  '' 0.5493061443340549-0i   -- 1/2 is inside the real domain
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
