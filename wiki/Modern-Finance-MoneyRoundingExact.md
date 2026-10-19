[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MoneyRoundingExact**

# MoneyRoundingExact

Returns a policy that never rounds, to keep full precision or see what rounding costs.

## Syntax

```freebasic
MoneyRoundingExact( )
```

## Examples

```freebasic
#import "std/money"
using money

'' The analytical policy: RoundEach_ is false, so MoneyRound is the
'' identity and a schedule carries full precision to the end.  Use it to
'' see what the rounding is costing.
dim as MoneyRounding p = MoneyRoundingExact( )

print p.RoundEach_                       '' false

dim as Decimal d = DecimalParse( "1.23456789012345678901234567" ).Value( )
print ( MoneyRound( d, p ) = d )         '' true -- untouched
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincore.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
