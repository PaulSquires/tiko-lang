[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **CumulativeReturnSeries**

# CumulativeReturnSeries

## Syntax

```freebasic
CumulativeReturnSeries( periodReturns( ) )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The compounded return after each observation -- what a growth-of-100
'' chart plots.
dim as double r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as double b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

var cum = CumulativeReturnSeries( r( ) )
print cum.Value( ).Count( )              '' 12

'' The first entry is just the first return.
print cum.Value( ).At( 0 )               '' 0.02

'' And the LAST equals the time-weighted return, which ties the series
'' to the scalar rather than leaving them independently computed.
print cum.Value( ).At( 11 )              '' 0.1410864155548182
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finport.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
