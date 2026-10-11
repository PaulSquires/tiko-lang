[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **SubSaturating**

# SubSaturating

A - b, **clamped** to the limits of the type instead of overflowing.

## Syntax

```freebasic
SubSaturating( byval a as T, byval b as T ) as T
```

## Notes

- Saturating: a result past the top comes back as the maximum and one past the bottom as the minimum, which is what signal and audio code wants -- a sample that clips is better than one that wraps to the opposite sign.
- No Optional, no branch at the call site: it always returns a `T`.
- `SubChecked` reports the overflow instead, and `SubWrapping` wraps.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as int8 a = 100, b = 100

print SubSaturating( a, b )     '' 127 -- clamped to the maximum, not wrapped

dim as int8 lo = -100, lo2 = -100
print SubSaturating( lo, lo2 )   '' -128 -- clamped at the other end
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
