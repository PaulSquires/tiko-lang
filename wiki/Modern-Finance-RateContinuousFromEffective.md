[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **RateContinuousFromEffective**

# RateContinuousFromEffective

Returns the continuously compounded rate that gives an effective yearly return.

## Syntax

```freebasic
RateContinuousFromEffective( effectiveAnnual )
```

## Examples

```freebasic
#import "std/money"
using money

'' The continuously-compounded rate that produces a given effective
'' annual return: ln( 1 + e ).
dim as Decimal eff = DecimalParse( "0.05" ).Value( )

print RateContinuousFromEffective( eff ).Value( ).ToStringFixed( 10 )   '' 0.0487901642

'' It is always BELOW the effective rate it produces -- compounding
'' continuously needs less nominal rate to get there.
print ( RateContinuousFromEffective( eff ).Value( ) < eff )             '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincore.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
