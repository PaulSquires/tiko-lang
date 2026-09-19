[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **RaiseFpException**

# RaiseFpException

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
RaiseFpException( e )
```

## Examples

```freebasic
#include once "fb/fenv.bi"
using FB

'' Raises a flag by hand, so a routine can report a condition through
'' the same channel the hardware uses
ClearFpExceptions( )
print RaiseFpException( FP_INVALID )      '' true

print TestFpException( FP_INVALID )       '' true
ClearFpExceptions( )
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
