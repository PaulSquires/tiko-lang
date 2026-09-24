[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalMinusOne**

# DecimalMinusOne

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DecimalMinusOne( )
```

## Examples

```freebasic
#include once "fb/decimal.bi"
using FB

'' Minus one at scale 0.  Multiplying by it negates without the unary
'' operator, and it is what Sign( ) is reporting against
print DecimalMinusOne( ).ToString( )       '' -1
print DecimalMinusOne( ).Sign( )           '' -1
print DecimalMinusOne( ).IsNegative( )     '' true

print ( DecimalParse( "1.25" ).Value( ) * DecimalMinusOne( ) ).ToString( )
'' -1.25
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
