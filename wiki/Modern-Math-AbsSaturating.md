[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **AbsSaturating**

# AbsSaturating

The absolute value, clamping the one input that has none.

## Syntax

```freebasic
AbsSaturating( byval a as T ) as T
```

## Notes

- The most negative value clamps to the **maximum** rather than staying negative, which is the least surprising answer available.
- `AbsChecked` reports that case instead of papering over it.

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

dim as byte worst = -128
print AbsSaturating( worst ) '' 127 -- clamped, not left negative

dim as byte ordinary = -5
print AbsSaturating( ordinary )               '' 5
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
