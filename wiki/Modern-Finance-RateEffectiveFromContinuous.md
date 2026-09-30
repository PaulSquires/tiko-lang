[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **RateEffectiveFromContinuous**

# RateEffectiveFromContinuous

## Syntax

```freebasic
RateEffectiveFromContinuous( continuousRate )
```

## Examples

```freebasic
#import "std/money"
using FB

'' exp( r ) - 1 -- the effective annual return of a continuously
'' compounded rate.
dim as Decimal r = DecimalParse( "0.0487901642" ).Value( )

print RateEffectiveFromContinuous( r ).Value( ).ToStringFixed( 8 )      '' 0.05000000

'' Round trip against RateContinuousFromEffective.
dim as Decimal eff = DecimalParse( "0.08" ).Value( )
dim as Decimal c = RateContinuousFromEffective( eff ).Value( )
print RateEffectiveFromContinuous( c ).Value( ).Round( 12 ).ToString( )
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
