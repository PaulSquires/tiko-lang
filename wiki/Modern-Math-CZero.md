[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CZero**

# CZero

The complex number zero.

## Syntax

```freebasic
CZero( ) as Complex
```

## Notes

- **A function, not a constant.** `const as Complex` cannot be initialised from a division by zero, so the whole family is spelled with parentheses for consistency with `CNaN` and `CInfinity`, which have no choice.
- `CIsZero( CZero( ) )` is true, and so is `CIsReal( CZero( ) )`.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CToString( CZero( ) )  '' 0+0i
print CIsZero( CZero( ) )    '' true
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
