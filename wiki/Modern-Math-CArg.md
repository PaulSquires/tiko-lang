[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CArg**

# CArg

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The phase — the angle from the positive real axis, in radians.

## Syntax

```freebasic
CArg( byref z as Complex ) as double
```

## Notes

- Principal value, on **(-π, π]**. `atan2`'s convention, which is also C99's.
- **The sign of a zero imaginary part decides the answer on the negative real axis**: `CArg( -1 + 0i )` is `+π` and `CArg( -1 - 0i )` is `-π`. That is the branch cut, and it is visible only because the two zeros are distinguishable.
- AfxNova spelled this `CArg`, `CArgument` and `CPhase`.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CArg( CSet( 1, 0 ) )      '' 0
print CArg( CSet( 0, 1 ) )      '' 1.570796326794897   -- PI/2
print CArg( CSet( -1, 0.0 ) )   '' 3.141592653589793   -- above the cut
print CArg( CSet( -1, -0.0 ) )  '' -3.141592653589793   -- below it
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
