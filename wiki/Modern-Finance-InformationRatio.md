[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **InformationRatio**

# InformationRatio

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
InformationRatio( assetReturns( ), benchmarkReturns( ), frequency )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Active return per unit of tracking error -- how much out-performance
'' the manager bought with each unit of deviation from the index.
dim as double r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as double b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

print InformationRatio( r( ), b( ), RETURN_MONTHLY ).Value( )    '' 1.63651467651115

'' An index fund has zero tracking error, so no information ratio --
'' named rather than an infinity.
print InformationRatio( b( ), b( ), RETURN_MONTHLY ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finport.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
