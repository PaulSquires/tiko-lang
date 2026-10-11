[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **NetFutureValue**

# NetFutureValue

## Syntax

```freebasic
NetFutureValue( flows( ), ratePerPeriod )
```

## Examples

```freebasic
#import "std/money"
using money

'' The net present value carried forward to the end of the series.
dim as Decimal f( 0 to 4 ) = { DecimalParse( "-1000" ).Value( ), _
                               DecimalParse( "300" ).Value( ), _
                               DecimalParse( "400" ).Value( ), _
                               DecimalParse( "500" ).Value( ), _
                               DecimalParse( "200" ).Value( ) }

print NetFutureValue( f( ), DecimalParse( "0.10" ).Value( ) ).Value( ).ToStringFixed( 4 )    '' 169.2000

'' It is the NPV grown over the term, which is the relationship that
'' keeps the two consistent.
dim as Decimal npv = NetPresentValue( f( ), DecimalParse( "0.10" ).Value( ) ).Value( )
dim as Decimal g = GrowthFactor( DecimalParse( "0.10" ).Value( ), 4 ).Value( )
print ( npv * g ).ToStringFixed( 4 )                                                          '' 169.2000
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincash.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
