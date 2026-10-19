[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **AbsSaturating**

# AbsSaturating

Returns the absolute value; the most negative value becomes the maximum instead.

## Syntax

```freebasic
AbsSaturating( byval a as T ) as T
```

## Notes

- The most negative value clamps to the **maximum** rather than staying negative, which is the least surprising answer available.
- `AbsChecked` reports that case instead of papering over it.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as int8 worst = -128
print AbsSaturating( worst ) '' 127 -- clamped, not left negative

dim as int8 ordinary = -5
print AbsSaturating( ordinary )               '' 5
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
