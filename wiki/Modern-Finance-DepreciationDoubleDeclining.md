[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DepreciationDoubleDeclining**

# DepreciationDoubleDeclining

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DepreciationDoubleDeclining( terms, period )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Declining balance at twice the straight-line rate.  It IGNORES
'' RateFactor_ and forces 2 -- otherwise "double" would be a lie whenever
'' the field had been set.
dim as DepreciationTerms t = DepreciationTermsMake( DecimalParse( "50000" ).Value( ), _
                                                    DecimalParse( "5000" ).Value( ), 7 )

print DepreciationDoubleDeclining( t, 1 ).Value( ).ToStringFixed( 2 )    '' 14285.71
print DepreciationDoubleDeclining( t, 2 ).Value( ).ToStringFixed( 2 )    '' 10204.08

t.RateFactor_ = DecimalParse( "1.5" ).Value( )
print DepreciationDoubleDeclining( t, 1 ).Value( ).ToStringFixed( 2 )    '' 14285.71

'' THE SALVAGE FLOOR IS ABSOLUTE: once the book value reaches salvage the
'' expense is exactly zero, never a small residue and never negative.
dim as DepreciationTerms a = DepreciationTermsMake( DecimalParse( "10000" ).Value( ), _
                                                    DecimalParse( "2000" ).Value( ), 5 )
print DepreciationDoubleDeclining( a, 4 ).Value( ).ToStringFixed( 2 )    '' 160.00
print DepreciationDoubleDeclining( a, 5 ).Value( ).IsZero( )             '' true
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/findeprec.bi` in the tiko-lang repository.
