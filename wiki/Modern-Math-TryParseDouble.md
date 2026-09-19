[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TryParseDouble**

# TryParseDouble

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TryParseDouble( s [, flags] )
```

## Examples

```freebasic
#include once "fb/mathtext.bi"
using FB

'' An Optional, so failure is absence rather than a zero that cannot be
'' told apart from a parsed "0"
var r = TryParseDouble( "1.5" )
print r.HasValue( )          '' true
print r.Value( )             '' 1.5

print TryParseDouble( "" ).HasValue( )        '' false
print TryParseDouble( "12abc" ).HasValue( )   '' false -- trailing junk

'' STRICT BY DEFAULT: no locale, no partial acceptance
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
