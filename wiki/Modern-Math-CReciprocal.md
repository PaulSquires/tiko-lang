[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CReciprocal**

# CReciprocal

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

One divided by the operand.

## Syntax

```freebasic
CReciprocal( byref z as Complex ) as Complex
```

## Notes

- **Zero gives zero**, not an infinity. That is .NET's answer and it is pinned by a test; it is a choice, not a law.
- Uses Smith's formula, so it does not overflow for operands near the type maximum.
- `z * CReciprocal( z )` is `COne( )` to within rounding.
- The `Asec`/`Acsc`/`Acot` family and the six `Sec`/`Csc`/`Cot` functions are all this composed with something else.
- AfxNova spelled this `CReciprocal` and `CInverse`.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

dim as Complex z = CSet( 3, 4 )

print CToString( CReciprocal( z ) )         '' 0.12-0.16i
print CToString( z * CReciprocal( z ) )     '' 1+0i
print CToString( CReciprocal( CZero( ) ) )  '' 0+0i   -- zero, .NET's answer
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
