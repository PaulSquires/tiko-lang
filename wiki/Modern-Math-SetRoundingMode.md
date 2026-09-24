[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **SetRoundingMode**

# SetRoundingMode

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
SetRoundingMode( m )
```

## Examples

```freebasic
#include once "fb/fenv.bi"
using FB

'' PROCESS-WIDE AND STICKY: it changes every later floating-point
'' operation in the program, not just the next one. Put it back.
dim as long was = GetRoundingMode( )

print SetRoundingMode( ROUND_TOWARD_ZERO )       '' true
print GetRoundingMode( ) = ROUND_TOWARD_ZERO     '' -1 (true)

SetRoundingMode( was )
print GetRoundingMode( ) = was                   '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
