[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalInvalid**

# DecimalInvalid

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DecimalInvalid( )
```

## Examples

```freebasic
#include once "fb/decimal.bi"
using FB

'' The one representation that is not a number -- scale 255, which no
'' value can have.  Overflow, division by zero and a conversion that will
'' not fit all produce it
print DecimalInvalid( ).ToString( )   '' Invalid
print DecimalInvalid( ).IsValid( )    '' false

print ( DecimalMaxValue( ) + DecimalOne( ) ).IsValid( )   '' false
print ( DecimalOne( ) / DecimalZero( ) ).IsValid( )       '' false

'' It is INFECTIOUS: anything touching it is Invalid too
print ( DecimalInvalid( ) * DecimalOne( ) ).IsValid( )    '' false

'' and INVALID = INVALID IS FALSE, the same rule fb/currency.bi and
'' fb/chrono.bi use.  Test with IsValid( ), never with =
print ( DecimalInvalid( ) = DecimalInvalid( ) )           '' false
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the tiko-lang repository.
