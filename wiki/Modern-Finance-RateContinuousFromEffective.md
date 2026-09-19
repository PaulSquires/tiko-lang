[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **RateContinuousFromEffective**

# RateContinuousFromEffective

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
RateContinuousFromEffective( effectiveAnnual )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The continuously-compounded rate that produces a given effective
'' annual return: ln( 1 + e ).
dim as Decimal eff = DecimalParse( "0.05" ).Value( )

print RateContinuousFromEffective( eff ).Value( ).ToStringFixed( 10 )   '' 0.0487901642

'' It is always BELOW the effective rate it produces -- compounding
'' continuously needs less nominal rate to get there.
print ( RateContinuousFromEffective( eff ).Value( ) < eff )             '' true
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the tiko-lang repository.
