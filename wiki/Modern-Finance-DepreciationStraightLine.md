[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DepreciationStraightLine**

# DepreciationStraightLine

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DepreciationStraightLine( terms, period )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The depreciable base spread evenly: ( cost - salvage ) / life.
dim as DepreciationTerms t = DepreciationTermsMake( DecimalParse( "50000" ).Value( ), _
                                                    DecimalParse( "5000" ).Value( ), 7 )

print DepreciationStraightLine( t, 1 ).Value( ).ToStringFixed( 2 )       '' 6428.57
print DepreciationStraightLine( t, 4 ).Value( ).ToStringFixed( 2 )       '' 6428.57

'' A clean division is exact everywhere.
dim as DepreciationTerms clean = DepreciationTermsMake( DecimalParse( "10000" ).Value( ), _
                                                        DecimalZero( ), 4 )
print DepreciationStraightLine( clean, 1 ).Value( ).ToString( )          '' 2500

'' A period past the end is a named refusal, not a zero.
print DepreciationStraightLine( t, 8 ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/findeprec.bi` in the tiko-lang repository.
