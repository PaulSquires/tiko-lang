[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **CorrelationToBenchmark**

# CorrelationToBenchmark

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
CorrelationToBenchmark( assetReturns( ), benchmarkReturns( ) )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' How tightly the two move together, between -1 and 1.
dim as double r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as double b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

print CorrelationToBenchmark( r( ), b( ) ).Value( )      '' 0.9968135918762368

'' A DOUBLED benchmark has correlation 1 but beta 2 -- correlation
'' measures tightness, beta measures the slope, and confusing the two is
'' a common mistake.
dim as double lev( 0 to 11 )
for k as long = 0 to 11
    lev( k ) = 2.0 * b( k )
next
print CorrelationToBenchmark( lev( ), b( ) ).Value( )    '' 1
print Beta( lev( ), b( ) ).Value( )                      '' 2
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finport.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
