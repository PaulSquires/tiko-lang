[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CIsFinite**

# CIsFinite

True when both components are finite.

## Syntax

```freebasic
CIsFinite( byref z as Complex ) as boolean
```

## Notes

- Finite means neither infinite nor NaN, in **both** components.
- `CIsFinite`, `CIsInfinite` and `CIsNaN` partition the complex numbers: exactly one of the three is true for any operand.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CIsFinite( CSet( 3, 4 ) )            '' true
print CIsFinite( CSet( 3, Infinity( ) ) )  '' false
print CIsFinite( CNaN( ) )                 '' false
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
