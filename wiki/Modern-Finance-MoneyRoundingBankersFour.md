[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MoneyRoundingBankersFour**

# MoneyRoundingBankersFour

## Syntax

```freebasic
MoneyRoundingBankersFour( )
```

## Examples

```freebasic
#import "std/money"
using FB

'' Four places, half-to-even -- the resolution FB.Currency carries, for
'' callers reconciling against a Currency-based ledger.
dim as MoneyRounding p = MoneyRoundingBankersFour( )

print p.Digits_                                                       '' 4
print MoneyRound( DecimalParse( "1.000050" ).Value( ), p ).ToString( )  '' 1.0000
print MoneyRound( DecimalParse( "1.000150" ).Value( ), p ).ToString( )  '' 1.0002
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
