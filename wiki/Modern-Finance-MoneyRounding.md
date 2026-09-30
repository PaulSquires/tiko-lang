[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MoneyRounding**

# MoneyRounding

## Syntax

```freebasic
p.Digits_  p.Mode_  p.RoundEach_
```

## Examples

```freebasic
#import "std/money"
using FB

'' A rounding policy: how many places, which mode, and whether to round
'' every posted amount or only on output.
dim as MoneyRounding p = MoneyRoundingCents( )

dim as boolean halfEven = ( p.Mode_ = DEC_HALF_EVEN )
print p.Digits_                          '' 2
print halfEven                           '' true
print p.RoundEach_                       '' true

'' The mode enum is fb/decimal.bi's own -- one rule to learn, not two.
dim as MoneyRounding up_ = MoneyRoundingMake( 2, DEC_HALF_UP, true )
print MoneyRound( DecimalParse( "2.665" ).Value( ), p ).ToString( )    '' 2.66
print MoneyRound( DecimalParse( "2.665" ).Value( ), up_ ).ToString( )  '' 2.67
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
