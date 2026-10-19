[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **SimpleInterestBetween**

# SimpleInterestBetween

Returns simple interest between two dates on a day-count basis you choose.

## Syntax

```freebasic
SimpleInterestBetween( principal, annualRate, d1, d2, basis )
```

## Examples

```freebasic
#import "std/chrono"
#import "std/money"
using money, chrono

'' Simple interest across a real date span, on a chosen day-count basis.
dim as Decimal p = DecimalParse( "10000" ).Value( )
dim as Decimal r = DecimalParse( "0.05" ).Value( )
dim as LocalDate a = LocalDate( 2026, 1, 1 )
dim as LocalDate b = LocalDate( 2027, 1, 1 )

print SimpleInterestBetween( p, r, a, b, DAYCOUNT_ACTUAL_365_FIXED ).ToString( )   '' 500.00

'' Act/360 charges more over the same span -- 365 days over a 360-day
'' year -- which is exactly why the basis is a parameter.
print ( SimpleInterestBetween( p, r, a, b, DAYCOUNT_ACTUAL_360 ) > _
        DecimalFromInt( 500 ) )                                                    '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincore.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
