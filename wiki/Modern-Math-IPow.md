[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IPow**

# IPow

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

EXACT -- IPow( 3LL, 38LL ) = 1350851717672992089

## Syntax

```freebasic
IPow( base, exp )
```

## Notes

- EXACT -- IPow( 3LL, 38LL ) = 1350851717672992089

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

'' INTEGER power by squaring -- exact, with no trip through double
dim as longint b = 2, e = 10
print IPow( b, e )           '' 1024

'' `2 ^ 10` goes through floating point and comes back as a double, so
'' it is exact only while the result fits in 53 bits. This is exact to
'' the full integer width.
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
