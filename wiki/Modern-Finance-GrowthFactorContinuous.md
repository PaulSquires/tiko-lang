[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **GrowthFactorContinuous**

# GrowthFactorContinuous

Returns what one unit grows to over a number of years with continuous compounding.

## Syntax

```freebasic
GrowthFactorContinuous( continuousRate, years )
```

## Examples

```freebasic
#import "std/money"
using money

'' exp( r * t ) -- continuous compounding, the limit of compounding ever
'' more often.  Double kernel.
dim as Decimal r = DecimalParse( "0.05" ).Value( )

print GrowthFactorContinuous( r, 1.0 ).Value( ).ToStringFixed( 10 )   '' 1.0512710964
print GrowthFactorContinuous( r, 0.0 ).Value( ).ToStringFixed( 10 )   '' 1.0000000000

'' Continuous always beats any discrete frequency at the same nominal
'' rate, which is what "the limit" means.
print ( GrowthFactorContinuous( r, 1.0 ).Value( ) > _
        GrowthFactor( RatePerPeriod( r, COMPOUND_DAILY_365 ).Value( ), 365 ).Value( ) )  '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincore.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
