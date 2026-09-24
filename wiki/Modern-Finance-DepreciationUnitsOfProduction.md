[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DepreciationUnitsOfProduction**

# DepreciationUnitsOfProduction

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DepreciationUnitsOfProduction( terms, unitsThisPeriod, totalUnits )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Depreciation by USE rather than by time -- the base times this
'' period's share of the asset's total expected output.
dim as DepreciationTerms t = DepreciationTermsMake( DecimalParse( "50000" ).Value( ), _
                                                    DecimalParse( "5000" ).Value( ), 7 )

'' A tenth of the lifetime units is a tenth of the 45000 base.
print DepreciationUnitsOfProduction( t, DecimalParse( "1000" ).Value( ), _
                                     DecimalParse( "10000" ).Value( ) ).Value( ).ToString( )   '' 4500

print DepreciationUnitsOfProduction( t, DecimalZero( ), _
                                     DecimalParse( "10000" ).Value( ) ).Value( ).IsZero( )     '' true

'' Zero total units is a named refusal, not an infinity.
print DepreciationUnitsOfProduction( t, DecimalParse( "100" ).Value( ), _
                                     DecimalZero( ) ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/findeprec.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
