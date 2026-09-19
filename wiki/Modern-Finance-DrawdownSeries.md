[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DrawdownSeries**

# DrawdownSeries

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DrawdownSeries( periodReturns( ) )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The fall from the RUNNING PEAK at each observation -- not from the
'' start of the series.  Both definitions are in use; this is the
'' standard one.
dim as double r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as double b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

var dd = DrawdownSeries( r( ) )
print dd.Value( ).Count( )               '' 12

'' EVERY VALUE IS <= 0, and a new high is exactly zero.
print dd.Value( ).At( 0 )                '' 0
print dd.Value( ).At( 4 )                '' -0.02500000000000009

'' MaxDrawdown reports the MAGNITUDE as a positive number -- the
'' asymmetry is deliberate, because "a 20% drawdown" is how it is quoted.
print MaxDrawdown( r( ) ).Value( )       '' 0.02500000000000009
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finport.bi` in the tiko-lang repository.
