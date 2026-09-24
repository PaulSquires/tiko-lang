[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MoneyRound**

# MoneyRound

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
MoneyRound( value, policy )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Applies a policy.  With RoundEach_ false it returns the value whole,
'' which is what makes an analytical run possible without a second code
'' path through every schedule.
dim as Decimal d = DecimalParse( "1234.5678" ).Value( )

print MoneyRound( d, MoneyRoundingCents( ) ).ToString( )        '' 1234.57
print MoneyRound( d, MoneyRoundingBankersFour( ) ).ToString( )  '' 1234.5678
print MoneyRound( d, MoneyRoundingExact( ) ).ToString( )        '' 1234.5678
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
