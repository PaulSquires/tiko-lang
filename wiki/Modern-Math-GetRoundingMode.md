[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **GetRoundingMode**

# GetRoundingMode

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
GetRoundingMode( )
```

## Examples

```freebasic
#include once "fb/fenv.bi"
using FB

'' The FPU's current rounding direction. TO NEAREST by default, which
'' is why RoundHalfEven agrees with the hardware and Round does not.
print GetRoundingMode( ) = ROUND_TO_NEAREST      '' -1 (true)

'' The names are ROUND_*, not the C FE_* spellings -- ROUND_TO_NEAREST,
'' ROUND_TOWARD_NEGATIVE, ROUND_TOWARD_POSITIVE, ROUND_TOWARD_ZERO
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
