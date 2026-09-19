[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalMaxValue**

# DecimalMaxValue

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DecimalMaxValue( )
```

## Examples

```freebasic
#include once "fb/decimal.bi"
using FB

'' 2^96-1 at scale 0 -- the largest value the type holds
print DecimalMaxValue( ).ToString( )
'' 79228162514264337593543950335

'' all three mantissa limbs full
dim as Decimal m = DecimalMaxValue( )
print m.Lo( ); " "; m.Mid( ); " "; m.Hi( )
'' 4294967295 4294967295 4294967295

'' One past it is Invalid rather than a wrapped number
print ( DecimalMaxValue( ) + DecimalOne( ) ).IsValid( )    '' false
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the tiko-lang repository.
