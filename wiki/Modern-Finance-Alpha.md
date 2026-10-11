[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **Alpha**

# Alpha

## Syntax

```freebasic
Alpha( assetReturns( ), benchmarkReturns( ), riskFreePerPeriod, frequency )
```

## Examples

```freebasic
#import "std/money"
using money

'' Jensen's alpha, annualized: the excess earned beyond what the
'' portfolio's beta exposure to the benchmark would explain.
dim as float64 r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as float64 b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

print Alpha( r( ), b( ), 0.0002, RETURN_MONTHLY ).Value( )       '' 0.0007384440443476345

'' A portfolio that IS its benchmark has no alpha, by construction --
'' zero to within floating-point residue, which is why this is a
'' tolerance rather than a comparison against exactly 0.
dim as boolean noAlpha = _
    ( abs( Alpha( b( ), b( ), 0.0002, RETURN_MONTHLY ).Value( ) ) < 1.0e-12 )
print noAlpha                            '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finport.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
