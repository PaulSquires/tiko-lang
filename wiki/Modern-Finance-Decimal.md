[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **Decimal**

# Decimal

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Decimal(1)
Decimal(2)
```

## Examples

```freebasic
#include once "fb/decimal.bi"
using FB

'' A 128-BIT DECIMAL: a 96-bit mantissa, a scale of 0..28 and a sign, so
'' money arithmetic is exact where a double is not.  This is the .NET
'' System.Decimal, the COM DECIMAL, and SQL Server's decimal(28,s)
dim as Decimal c = DecimalFromDouble( 0.1 )
dim as Decimal d = DecimalFromDouble( 0.2 )

print ( c + d ).ToString( )  '' 0.3 -- exact

'' The double sum PRINTS as 0.3, which is why the error is so easy to
'' miss, but it is not 0.3 and the comparison says so
print 0.1 + 0.2              '' 0.3
print ( 0.1 + 0.2 = 0.3 )    '' 0 -- false

'' THE SCALE IS PART OF THE VALUE.  1.10 and 1.1 are EQUAL and print
'' DIFFERENTLY, so a price read back from a file prints as it was written
print DecimalParse( "1.10" ).Value( ).ToString( )   '' 1.10
print DecimalParse( "1.1"  ).Value( ).ToString( )   '' 1.1
print DecimalParse( "1.10" ).Value( ) = _
      DecimalParse( "1.1"  ).Value( )               '' true

'' 28 significant digits, where fb/currency.bi has four decimal places
print ( DecimalParse( "19.99" ).Value( ) * 3 ).ToString( )   '' 59.97
print ( DecimalFromInt( 1 ) / DecimalFromInt( 3 ) ).ToString( )
'' 0.3333333333333333333333333333

print len( DecimalZero( ) )  '' 16 -- the same sixteen bytes as tagDEC
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
