[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CSgn**

# CSgn

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The unit vector in the operand's direction.

## Syntax

```freebasic
CSgn( byref z as Complex ) as Complex
```

## Notes

- `z / CAbs( z )`, and `CZero( )` for zero. This is Mathematica's `Sign[z]` and the only meaning of *sign* that survives on ℂ.
- **Deliberately different from AfxNova**, whose `CSgn` returned a `LONG`: `+1` if the real part was positive, else `-1` if negative, else the same test on the imaginary part. That is a lexicographic tie-break, not a sign, and this header declines to give ℂ an ordering. Code ported from AfxNova gets a **compile error** at the assignment rather than a silently different number.
- The result has modulus 1 and the same argument as the operand.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

dim as Complex z = CSet( 3, 4 )

print CToString( CSgn( z ) )         '' 0.6+0.8i
print CAbs( CSgn( z ) )              '' 1   -- always 1
print CToString( CSgn( CZero( ) ) )  '' 0+0i
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
