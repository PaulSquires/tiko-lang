[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **SortinoRatio**

# SortinoRatio

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
SortinoRatio( periodReturns( ), targetPerPeriod, frequency )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Sharpe's cousin, dividing by DOWNSIDE deviation instead of total
'' volatility -- so a portfolio is not penalised for rising sharply.
dim as double r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as double b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

print SortinoRatio( r( ), 0.0, RETURN_MONTHLY ).Value( )         '' 4.323460152737352

'' It EXCEEDS Sharpe here, and must: this series has more upside
'' volatility than downside, which is exactly what Sortino ignores.
dim as boolean higher = ( SortinoRatio( r( ), 0.0, RETURN_MONTHLY ).Value( ) > _
                          SharpeRatio( r( ), 0.0, RETURN_MONTHLY ).Value( ) )
print higher                             '' true

'' Never below target means no downside deviation and so no ratio.
dim as double up_( 0 to 3 ) = { 0.01, 0.02, 0.01, 0.03 }
print SortinoRatio( up_( ), 0.0, RETURN_MONTHLY ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finport.bi` in the tiko-lang repository.
