[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DepreciationTerms**

# DepreciationTerms

## Syntax

```freebasic
t.Cost_  t.Salvage_  t.LifePeriods_  t.RateFactor_  t.PlacedInService_  t.Rounding_
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' What an asset is worth, what it will be worth, and over how long.
'' LifePeriods_ is PERIODS, not years -- a monthly schedule passes 84,
'' not 7, which is why the field is named the way it is.
dim as DepreciationTerms t = DepreciationTermsMake( DecimalParse( "50000" ).Value( ), _
                                                    DecimalParse( "5000" ).Value( ), 7 )

print t.LifePeriods_                     '' 7
print t.Cost_.ToString( )                '' 50000
print t.RateFactor_.ToString( )          '' 2 -- double declining, by default
print t.PlacedInService_.ToString( )     '' 1 -- a whole first period

'' A 150%-declining-balance caller assigns the factor after construction.
t.RateFactor_ = DecimalParse( "1.5" ).Value( )
print DepreciationDecliningBalance( t, 1 ).Value( ).ToStringFixed( 2 )   '' 10714.29
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/findeprec.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
