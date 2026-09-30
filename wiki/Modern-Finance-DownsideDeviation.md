[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DownsideDeviation**

# DownsideDeviation

## Syntax

```freebasic
DownsideDeviation( periodReturns( ), targetPerPeriod, frequency )
```

## Examples

```freebasic
#import "std/money"
using FB

'' Only the SHORTFALL against a target counts -- upside volatility is
'' ignored, which is what makes it the right denominator for Sortino.
''
'' IT IS NOT StdDev OF THE BELOW-TARGET VALUES: it measures deviation
'' from the TARGET, not from their mean, and divides by the FULL
'' observation count so that rarely being below target is rewarded.
dim as float64 r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as float64 b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

print DownsideDeviation( r( ), 0.0, RETURN_MONTHLY ).Value( )    '' 0.03122498999199199

'' It is smaller than total volatility whenever there is upside.
dim as boolean smaller = ( DownsideDeviation( r( ), 0.0, RETURN_MONTHLY ).Value( ) < _
                           Volatility( r( ), RETURN_MONTHLY ).Value( ) )
print smaller                            '' true

'' A series never below target has exactly zero downside deviation.
dim as float64 up_( 0 to 3 ) = { 0.01, 0.02, 0.01, 0.03 }
print DownsideDeviation( up_( ), 0.0, RETURN_MONTHLY ).Value( )   '' 0
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finport.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
