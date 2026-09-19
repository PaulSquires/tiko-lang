[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CNegate**

# CNegate

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The negation — both components negated.

## Syntax

```freebasic
CNegate( byref z as Complex ) as Complex
```

## Notes

- The unary `-` operator does the same thing. This exists so that the operation has a name for the same reason `CConj` does.
- AfxNova spelled this `CNeg`, `CNegate` **and** `CNegative`; one name survives.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

dim as Complex z = CSet( 3, 4 )

print CToString( CNegate( z ) )  '' -3-4i
print CToString( -z )            '' -3-4i   -- the operator agrees
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
