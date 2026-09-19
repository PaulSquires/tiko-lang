[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalMinValue**

# DecimalMinValue

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DecimalMinValue( )
```

## Examples

```freebasic
#include once "fb/decimal.bi"
using FB

'' -(2^96-1) at scale 0 -- the most negative value the type holds.  The
'' range is SYMMETRIC, unlike a two's-complement integer, because the sign
'' is a separate bit rather than part of the magnitude
print DecimalMinValue( ).ToString( )
'' -79228162514264337593543950335

print ( DecimalMaxValue( ) + DecimalMinValue( ) ).IsZero( )   '' true
print DecimalMinValue( ).AbsValue( ) = DecimalMaxValue( )     '' true

'' which is why AbsValue( ) can never overflow here, where Currency's and
'' every integer type's can
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the tiko-lang repository.
