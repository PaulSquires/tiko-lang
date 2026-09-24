[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MoneyRoundingBankersFour**

# MoneyRoundingBankersFour

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
MoneyRoundingBankersFour( )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Four places, half-to-even -- the resolution FB.Currency carries, for
'' callers reconciling against a Currency-based ledger.
dim as MoneyRounding p = MoneyRoundingBankersFour( )

print p.Digits_                                                       '' 4
print MoneyRound( DecimalParse( "1.000050" ).Value( ), p ).ToString( )  '' 1.0000
print MoneyRound( DecimalParse( "1.000150" ).Value( ), p ).ToString( )  '' 1.0002
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
