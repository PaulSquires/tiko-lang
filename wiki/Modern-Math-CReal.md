[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CReal**

# CReal

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The real part.

## Syntax

```freebasic
CReal( byref z as Complex ) as double
```

## Notes

- `z.re` reads the same field. `CReal( z )` is the documented spelling because it survives a field rename and because it says at the call site that the operand is complex.
- `fb/vector.bi` used to spell this `Real`. That name is gone with the rest of the mixed scheme — see [What Is tiko-lang](What-Is-tiko-lang).

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

dim as Complex z = CSet( 3, 4 )

print CReal( z )  '' 3
print CImag( z )  '' 4
print z.re        '' 3   -- the field, same value
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
