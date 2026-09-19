[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TryParseLongInt**

# TryParseLongInt

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TryParseLongInt( s [, base] )
```

## Examples

```freebasic
#include once "fb/mathtext.bi"
using FB

var r = TryParseLongInt( "9223372036854775807" )
print r.HasValue( )          '' true
print r.Value( )             '' 9223372036854775807

'' One past the top is rejected rather than wrapped
print TryParseLongInt( "9223372036854775808" ).HasValue( ) '' false
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
