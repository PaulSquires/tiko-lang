[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MoneyRound**

# MoneyRound

## Syntax

```freebasic
MoneyRound( value, policy )
```

## Examples

```freebasic
#import "std/money"
using money

'' Applies a policy.  With RoundEach_ false it returns the value whole,
'' which is what makes an analytical run possible without a second code
'' path through every schedule.
dim as Decimal d = DecimalParse( "1234.5678" ).Value( )

print MoneyRound( d, MoneyRoundingCents( ) ).ToString( )        '' 1234.57
print MoneyRound( d, MoneyRoundingBankersFour( ) ).ToString( )  '' 1234.5678
print MoneyRound( d, MoneyRoundingExact( ) ).ToString( )        '' 1234.5678
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincore.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
