[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **SharpeRatio**

# SharpeRatio

Returns the annualized return above the risk-free rate per unit of volatility.

## Syntax

```freebasic
SharpeRatio( periodReturns( ), riskFreePerPeriod, frequency )
```

## Examples

```freebasic
#import "std/money"
using money

'' Excess return per unit of TOTAL risk, both annualized.
dim as float64 r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as float64 b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

print SharpeRatio( r( ), 0.0002, RETURN_MONTHLY ).Value( )       '' 1.870576573257002

'' A higher risk-free rate leaves less excess, so the ratio falls.
dim as boolean falls = ( SharpeRatio( r( ), 0.004, RETURN_MONTHLY ).Value( ) < _
                         SharpeRatio( r( ), 0.0002, RETURN_MONTHLY ).Value( ) )
print falls                              '' true

'' A constant series has no volatility, so no ratio -- a named refusal
'' rather than an infinity.
dim as float64 flat_( 0 to 3 ) = { 0.01, 0.01, 0.01, 0.01 }
print SharpeRatio( flat_( ), 0.0, RETURN_MONTHLY ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finport.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
