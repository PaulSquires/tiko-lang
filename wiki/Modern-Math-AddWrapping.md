[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **AddWrapping**

# AddWrapping

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

A + b, **wrapping** on overflow -- deliberately.

## Syntax

```freebasic
AddWrapping( byval a as T, byval b as T ) as T
```

## Notes

- Exactly what `a + b` already does. It exists so that **deliberate** wrapping -- a hash mix, a checksum, a ring index -- can be spelled as deliberate, and so a reader does not have to guess whether the author knew.
- No cost: it compiles to the same instruction as the operator.
- `AddChecked` is the one that reports overflow and `AddSaturating` the one that clamps.

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

dim as byte a = 100, b = 100

print AddWrapping( a, b )        '' -56 -- wrapped, and that is the point

'' The value of this over the bare operator is that the INTENT is on
'' the page: a reader does not have to work out whether the overflow
'' was known about
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
