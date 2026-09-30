[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **SummarizeReturns**

# SummarizeReturns

## Syntax

```freebasic
SummarizeReturns( periodReturns( ), riskFreePerPeriod, frequency )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Every headline figure in one call.  It is a CONVENIENCE, not a second
'' implementation -- each field equals its own standalone function.
dim as double r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as double b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

var s = SummarizeReturns( r( ), 0.0002, RETURN_MONTHLY )

print s.Value( ).Observations_           '' 12
print s.Value( ).Total_                  '' 0.1410864155548182
print s.Value( ).Volatility_             '' 0.07088723439378913
print s.Value( ).Sharpe_                 '' 1.870576573257002
print s.Value( ).MaxDrawdown_            '' 0.02500000000000009

'' The same number, from the standalone function.
print TimeWeightedReturn( r( ) ).Value( )                '' 0.1410864155548182
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finport.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
