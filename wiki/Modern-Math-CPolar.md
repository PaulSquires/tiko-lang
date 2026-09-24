[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CPolar**

# CPolar

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Builds a complex number from a modulus and a phase.

## Syntax

```freebasic
CPolar( byval r as double, byval theta as double ) as Complex
```

## Notes

- The inverse of `CAbs` and `CArg` taken together: `CPolar( CAbs( z ), CArg( z ) )` reproduces `z`.
- `theta` is in **radians**, measured anticlockwise from the positive real axis.
- A zero modulus collapses to the origin whatever the angle.
- AfxNova spelled this both `CPolar` and `CFromPolarCoordinates`; .NET calls it `FromPolarCoordinates`.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CToString( CPolar( 2.0, 0.0 ) )                   '' 2+0i   -- theta = 0 is the positive real axis
print CToString( CPolar( 5.0, CArg( CSet( 3, 4 ) ) ) )  '' 3.0000000000000004+3.9999999999999996i   -- back to 3+4i, near enough
print CAbs( CPolar( 1.5, 2.0 ) )                        '' 1.5   -- the modulus survives any angle
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
