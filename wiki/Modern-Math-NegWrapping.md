[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NegWrapping**

# NegWrapping

Negates an integer within its type, so the most negative value stays as it is.

## Syntax

```freebasic
NegWrapping( byval a as T ) as T
```

## Notes

- Wraps **within the type**: negating the most negative value returns it unchanged. Note this is NOT what the bare `-a` does on a narrow type -- that promotes to an integer first and can answer with a value that no longer fits.
- It exists so that deliberate wrapping can be spelled as deliberate.
- `NegChecked` reports the case and `NegSaturating` clamps it.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as int8 worst = -128
print NegWrapping( worst )   '' -128 -- wrapped back to itself

'' NOT identical to the bare operator, which PROMOTES to an integer and
'' so answers 128 -- a value that no longer fits in a BYTE. This one
'' stays in the type and wraps, which is what a checksum or ring index
'' wants.
print -worst                 '' 128

dim as int8 ordinary = 100
print NegWrapping( ordinary )                 '' -100
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
