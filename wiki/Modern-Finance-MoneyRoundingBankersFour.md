[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MoneyRoundingBankersFour**

# MoneyRoundingBankersFour

## Syntax

```freebasic
MoneyRoundingBankersFour( )
```

## Examples

```freebasic
#import "std/money"
using money

'' Four places, half-to-even -- the resolution money.Currency carries, for
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
**Source:** `pkg/std/money/fincore.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
