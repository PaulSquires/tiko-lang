[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NegWrapping**

# NegWrapping

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The negation, wrapping on the one input that overflows -- deliberately.

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
#include once "fb/mathint.bi"
using FB

dim as byte worst = -128
print NegWrapping( worst )   '' -128 -- wrapped back to itself

'' NOT identical to the bare operator, which PROMOTES to an integer and
'' so answers 128 -- a value that no longer fits in a BYTE. This one
'' stays in the type and wraps, which is what a checksum or ring index
'' wants.
print -worst                 '' 128

dim as byte ordinary = 100
print NegWrapping( ordinary )                 '' -100
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
