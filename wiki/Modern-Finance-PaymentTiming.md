[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **PaymentTiming**

# PaymentTiming

## Syntax

```freebasic
PAY_END_OF_PERIOD  PAY_BEGIN_OF_PERIOD
```

## Examples

```freebasic
#import "std/money"
using money

'' An ordinary annuity pays at the END of each period; an annuity due
'' pays at the START, so every payment works one period longer.
dim as Decimal i = DecimalParse( "0.005" ).Value( )

var ord_ = AnnuityPresentValueFactor( i, 12, PAY_END_OF_PERIOD )
var due  = AnnuityPresentValueFactor( i, 12, PAY_BEGIN_OF_PERIOD )

print ord_.Value( ).ToStringFixed( 6 )
print due.Value( ).ToStringFixed( 6 )

'' The difference is exactly one period of growth.
print ( due.Value( ) = ( ord_.Value( ) * ( DecimalOne( ) + i ) ) )   '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincore.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
