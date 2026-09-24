[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TryParseSingle**

# TryParseSingle

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TryParseSingle( s [, flags] )
```

## Examples

```freebasic
#include once "fb/mathtext.bi"
using FB

var r = TryParseSingle( "1.5" )
print r.HasValue( )          '' true
print r.Value( )             '' 1.5

'' A magnitude too large for a SINGLE is still accepted -- it becomes
'' an infinity rather than being rejected, so check IsFinite when that
'' matters
print TryParseSingle( "1e300" ).HasValue( )   '' true
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
