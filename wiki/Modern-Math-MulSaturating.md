[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **MulSaturating**

# MulSaturating

A * b, **clamped** to the limits of the type instead of overflowing.

## Syntax

```freebasic
MulSaturating( byval a as T, byval b as T ) as T
```

## Notes

- Saturating: a result past the top comes back as the maximum and one past the bottom as the minimum, which is what signal and audio code wants -- a sample that clips is better than one that wraps to the opposite sign.
- No Optional, no branch at the call site: it always returns a `T`.
- `MulChecked` reports the overflow instead, and `MulWrapping` wraps.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as int8 a = 100, b = 100

print MulSaturating( a, b )     '' 127 -- clamped to the maximum, not wrapped

dim as int8 lo = -100, lo2 = -100
print MulSaturating( lo, lo2 )   '' -128 -- clamped at the other end
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
