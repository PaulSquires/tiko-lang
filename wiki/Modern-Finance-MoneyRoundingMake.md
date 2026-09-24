[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MoneyRoundingMake**

# MoneyRoundingMake

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
MoneyRoundingMake( digits, mode, roundEach )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Build a policy explicitly when none of the three named ones fits --
'' here, three decimal places rounding away from zero.
dim as MoneyRounding p = MoneyRoundingMake( 3, DEC_UP, true )

print p.Digits_                                              '' 3
print MoneyRound( DecimalParse( "1.23401" ).Value( ), p ).ToString( )   '' 1.235
print MoneyRound( DecimalParse( "-1.23401" ).Value( ), p ).ToString( )  '' -1.235
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
