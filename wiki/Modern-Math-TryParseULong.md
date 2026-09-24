[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TryParseULong**

# TryParseULong

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TryParseULong( s )
```

## Examples

```freebasic
#include once "fb/mathtext.bi"
using FB

var r = TryParseULong( "4294967295" )
print r.HasValue( )          '' true
print r.Value( )             '' 4294967295

'' UNSIGNED, so a negative is rejected rather than wrapping to a huge
'' positive -- which is exactly the bug VAL would hand you
print TryParseULong( "-1" ).HasValue( )       '' false
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
