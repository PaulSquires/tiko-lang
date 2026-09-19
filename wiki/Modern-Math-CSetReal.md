[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CSetReal**

# CSetReal

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Assigns the real part in place.

## Syntax

```freebasic
CSetReal( byref z as Complex, byval x as double )
```

## Notes

- A **sub**, not a function: it modifies its argument and returns nothing.
- `z.re = x` does the same thing. This exists so that code written against the accessors does not have to reach for the field on the one occasion it assigns.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

dim as Complex z = CSet( 3, 4 )
CSetReal( z, 9 )

print CToString( z )  '' 9+4i   -- after CSetReal( z, 9 )
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
