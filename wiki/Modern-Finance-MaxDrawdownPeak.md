[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MaxDrawdownPeak**

# MaxDrawdownPeak

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
MaxDrawdownPeak( periodReturns( ) )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The index of the peak the worst drawdown fell FROM.
''
'' AN Optional, not a Result: a series that never drew down has no peak,
'' and that is the finding rather than a failure.
dim as double r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as double b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

print MaxDrawdownPeak( r( ) ).HasValue( )    '' true
print MaxDrawdownPeak( r( ) ).Value( )       '' 3

dim as double up_( 0 to 3 ) = { 0.01, 0.02, 0.01, 0.03 }
print MaxDrawdownPeak( up_( ) ).HasValue( )  '' false
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finport.bi` in the tiko-lang repository.
