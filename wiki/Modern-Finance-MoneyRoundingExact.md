[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MoneyRoundingExact**

# MoneyRoundingExact

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
MoneyRoundingExact( )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The analytical policy: RoundEach_ is false, so MoneyRound is the
'' identity and a schedule carries full precision to the end.  Use it to
'' see what the rounding is costing.
dim as MoneyRounding p = MoneyRoundingExact( )

print p.RoundEach_                       '' false

dim as Decimal d = DecimalParse( "1.23456789012345678901234567" ).Value( )
print ( MoneyRound( d, p ) = d )         '' true -- untouched
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the tiko-lang repository.
