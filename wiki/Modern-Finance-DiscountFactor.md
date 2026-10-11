[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DiscountFactor**

# DiscountFactor

## Syntax

```freebasic
DiscountFactor( ratePerPeriod, periods )
```

## Examples

```freebasic
#import "std/money"
using money

'' 1 / ( 1 + i )^n -- what a pound at period n is worth today.
dim as Decimal i = DecimalParse( "0.005" ).Value( )

print DiscountFactor( i, 0 ).Value( ).ToString( )           '' 1
print DiscountFactor( i, 12 ).Value( ).ToStringFixed( 8 )   '' 0.94190534

'' It is the reciprocal of GrowthFactor, so the two multiply to one.
dim as Decimal g = GrowthFactor( i, 120 ).Value( )
dim as Decimal v = DiscountFactor( i, 120 ).Value( )
print ( g * v ).Round( 20 ).ToString( )                     '' 1.00000000000000000000
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincore.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
