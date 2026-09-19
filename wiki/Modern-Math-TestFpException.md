[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TestFpException**

# TestFpException

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TestFpException( e )
```

## Examples

```freebasic
#include once "fb/fenv.bi"
using FB

'' The flags are STICKY: once raised they stay raised until cleared, so
'' a test after a long computation says "this happened at some point",
'' not "this just happened"
ClearFpExceptions( )
print TestFpException( FP_OVERFLOW )      '' false

dim as double big = 1e308
dim as double r = big * 10
print TestFpException( FP_OVERFLOW )      '' true
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
