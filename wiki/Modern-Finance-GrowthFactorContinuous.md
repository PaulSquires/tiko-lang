[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **GrowthFactorContinuous**

# GrowthFactorContinuous

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
GrowthFactorContinuous( continuousRate, years )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' exp( r * t ) -- continuous compounding, the limit of compounding ever
'' more often.  Double kernel.
dim as Decimal r = DecimalParse( "0.05" ).Value( )

print GrowthFactorContinuous( r, 1.0 ).Value( ).ToStringFixed( 10 )   '' 1.0512710964
print GrowthFactorContinuous( r, 0.0 ).Value( ).ToStringFixed( 10 )   '' 1.0000000000

'' Continuous always beats any discrete frequency at the same nominal
'' rate, which is what "the limit" means.
print ( GrowthFactorContinuous( r, 1.0 ).Value( ) > _
        GrowthFactor( RatePerPeriod( r, COMPOUND_DAILY_365 ).Value( ), 365 ).Value( ) )  '' true
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the tiko-lang repository.
