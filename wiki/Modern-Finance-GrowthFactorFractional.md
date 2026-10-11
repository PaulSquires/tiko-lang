[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **GrowthFactorFractional**

# GrowthFactorFractional

## Syntax

```freebasic
GrowthFactorFractional( ratePerPeriod, periods )
```

## Examples

```freebasic
#import "std/money"
using money

'' A FRACTIONAL number of periods, which needs a real power and so takes
'' the double kernel -- every function says which path it is on.
dim as Decimal i = DecimalParse( "0.06" ).Value( )

print GrowthFactorFractional( i, 0.5 ).Value( ).ToStringFixed( 10 )   '' 1.0295630141
print GrowthFactorFractional( i, 2.0 ).Value( ).ToStringFixed( 10 )   '' 1.1236000000

'' Half a period twice is one whole period.
dim as Decimal h = GrowthFactorFractional( i, 0.5 ).Value( )
print ( h * h ).Round( 10 ).ToString( )                               '' 1.0600000000
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincore.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
