[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **InformationRatio**

# InformationRatio

## Syntax

```freebasic
InformationRatio( assetReturns( ), benchmarkReturns( ), frequency )
```

## Examples

```freebasic
#import "std/money"
using money

'' Active return per unit of tracking error -- how much out-performance
'' the manager bought with each unit of deviation from the index.
dim as float64 r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as float64 b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

print InformationRatio( r( ), b( ), RETURN_MONTHLY ).Value( )    '' 1.63651467651115

'' An index fund has zero tracking error, so no information ratio --
'' named rather than an infinity.
print InformationRatio( b( ), b( ), RETURN_MONTHLY ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finport.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
