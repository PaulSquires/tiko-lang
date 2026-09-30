[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **AnnualizeReturnOverPeriods**

# AnnualizeReturnOverPeriods

## Syntax

```freebasic
AnnualizeReturnOverPeriods( totalReturn, periods, frequency )
```

## Examples

```freebasic
#import "std/money"
using FB

'' A total return spread over a known number of observations, then
'' annualized -- for when you have the whole-period figure rather than
'' the per-period one.
print AnnualizeReturnOverPeriods( 0.1410864155548182, 12, RETURN_MONTHLY ).Value( )

'' TWELVE MONTHLY OBSERVATIONS ANNUALIZE TO THEMSELVES: a full year of
'' data needs no scaling, which is a good check that it is not applied
'' twice.
print AnnualizeReturnOverPeriods( 0.20, 12, RETURN_MONTHLY ).Value( )     '' 0.2

'' Six months of 20% annualizes to considerably more.
dim as boolean scaledUp = ( AnnualizeReturnOverPeriods( 0.20, 6, RETURN_MONTHLY ).Value( ) > 0.2 )
print scaledUp                           '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finport.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
