[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **CurrencyParse**

# CurrencyParse

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
CurrencyParse( s )
```

## Examples

```freebasic
#include once "fb/currency.bi"
using FB

'' Parses text exactly, with no double in the middle
var r = CurrencyParse( "12.34" )
print r.HasValue( )          '' true
print r.Value( ).ToString( ) '' 12.3400

'' An Optional, so bad input is absence rather than a wrong number
print CurrencyParse( "not money" ).HasValue( )    '' false
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
