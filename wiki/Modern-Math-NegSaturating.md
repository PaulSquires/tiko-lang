[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NegSaturating**

# NegSaturating

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

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
#include once "fb/mathint.bi"
using FB

dim as byte worst = -128
print NegSaturating( worst ) '' 127 -- clamped, not left at -128

dim as byte ordinary = 100
print NegSaturating( ordinary )               '' -100
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
