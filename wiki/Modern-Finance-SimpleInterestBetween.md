[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **SimpleInterestBetween**

# SimpleInterestBetween

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
SimpleInterestBetween( principal, annualRate, d1, d2, basis )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Simple interest across a real date span, on a chosen day-count basis.
dim as Decimal p = DecimalParse( "10000" ).Value( )
dim as Decimal r = DecimalParse( "0.05" ).Value( )
dim as LocalDate a = LocalDate( 2026, 1, 1 )
dim as LocalDate b = LocalDate( 2027, 1, 1 )

print SimpleInterestBetween( p, r, a, b, DAYCOUNT_ACTUAL_365_FIXED ).ToString( )   '' 500.00

'' Act/360 charges more over the same span -- 365 days over a 360-day
'' year -- which is exactly why the basis is a parameter.
print ( SimpleInterestBetween( p, r, a, b, DAYCOUNT_ACTUAL_360 ) > _
        DecimalFromInt( 500 ) )                                                    '' true
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the tiko-lang repository.
