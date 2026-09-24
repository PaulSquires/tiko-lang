[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TryParseLong**

# TryParseLong

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TryParseLong( s )
```

## Examples

```freebasic
#include once "fb/mathtext.bi"
using FB

var r = TryParseLong( "42" )
print r.HasValue( )          '' true
print r.Value( )             '' 42

'' RANGE IS CHECKED: a value too big for the type is absent, not wrapped
print TryParseLong( "99999999999999" ).HasValue( )        '' false
print TryParseLong( "1.5" ).HasValue( )                    '' false -- not an integer
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
