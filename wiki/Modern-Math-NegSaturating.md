[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NegSaturating**

# NegSaturating

The negation, clamping the one input that has none.

## Syntax

```freebasic
NegSaturating( byval a as T ) as T
```

## Notes

- The most negative value clamps to the **maximum** instead of staying negative.
- Every other input negates normally.
- `NegChecked` reports that case rather than choosing an answer for you.

## Examples

```freebasic
#import "std/numeric"
using FB

dim as int8 worst = -128
print NegSaturating( worst ) '' 127 -- clamped, not left at -128

dim as int8 ordinary = 100
print NegSaturating( ordinary )               '' -100
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
