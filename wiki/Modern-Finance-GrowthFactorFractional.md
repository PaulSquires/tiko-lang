[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **GrowthFactorFractional**

# GrowthFactorFractional

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
GrowthFactorFractional( ratePerPeriod, periods )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' A FRACTIONAL number of periods, which needs a real power and so takes
'' the double kernel -- every function says which path it is on.
dim as Decimal i = DecimalParse( "0.06" ).Value( )

print GrowthFactorFractional( i, 0.5 ).Value( ).ToStringFixed( 10 )   '' 1.0295630141
print GrowthFactorFractional( i, 2.0 ).Value( ).ToStringFixed( 10 )   '' 1.1236000000

'' Half a period twice is one whole period.
dim as Decimal h = GrowthFactorFractional( i, 0.5 ).Value( )
print ( h * h ).Round( 10 ).ToString( )                               '' 1.0600000000
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
