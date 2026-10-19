[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MoneyRoundingMake**

# MoneyRoundingMake

Returns a rounding policy with the places, mode and round-each flag you choose.

## Syntax

```freebasic
MoneyRoundingMake( digits, mode, roundEach )
```

## Examples

```freebasic
#import "std/money"
using money

'' Build a policy explicitly when none of the three named ones fits --
'' here, three decimal places rounding away from zero.
dim as MoneyRounding p = MoneyRoundingMake( 3, DEC_UP, true )

print p.Digits_                                              '' 3
print MoneyRound( DecimalParse( "1.23401" ).Value( ), p ).ToString( )   '' 1.235
print MoneyRound( DecimalParse( "-1.23401" ).Value( ), p ).ToString( )  '' -1.235
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincore.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
