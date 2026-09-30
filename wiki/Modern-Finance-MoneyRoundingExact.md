[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MoneyRoundingExact**

# MoneyRoundingExact

## Syntax

```freebasic
MoneyRoundingExact( )
```

## Examples

```freebasic
#import "std/money"
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

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
