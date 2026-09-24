[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **Beta**

# Beta

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Beta( assetReturns( ), benchmarkReturns( ) )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The slope of the asset against its benchmark: how much it moves when
'' the benchmark moves by one.
''
'' SAMPLE COVARIANCE OVER SAMPLE VARIANCE.  The n-1 factors cancel, so
'' this is the regression slope -- what matters is not WHICH convention
'' but that BOTH legs use the same one.  Mixing them scales the answer
'' by (n-1)/n, which is the classic statistics bug.
dim as double r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as double b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

print Beta( r( ), b( ) ).Value( )        '' 1.140670899270349

'' A portfolio identical to its benchmark has beta 1.
print Beta( b( ), b( ) ).Value( )        '' 1

'' A constant benchmark has no variance, so no slope.
dim as double flat_( 0 to 11 )
for k as long = 0 to 11
    flat_( k ) = 0.01
next
print Beta( r( ), flat_( ) ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finport.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
