[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **NetPresentValueOnDates**

# NetPresentValueOnDates

Returns the net present value of dated flows at an annual rate on a day-count basis.

## Syntax

```freebasic
NetPresentValueOnDates( flows( ), annualRate, basis )
```

## Examples

```freebasic
#import "std/chrono"
#import "std/money"
using money, chrono

'' NPV over irregular DATES rather than equal periods.  The discount
'' exponent is a day-count fraction, so this takes the double kernel.
dim as CashFlow f( 0 to 3 )
f( 0 ) = CashFlowMake( DecimalParse( "-10000" ).Value( ), LocalDate( 2026, 1, 1 ) )
f( 1 ) = CashFlowMake( DecimalParse( "2750" ).Value( ),   LocalDate( 2026, 3, 1 ) )
f( 2 ) = CashFlowMake( DecimalParse( "4250" ).Value( ),   LocalDate( 2026, 10, 30 ) )
f( 3 ) = CashFlowMake( DecimalParse( "3250" ).Value( ),   LocalDate( 2027, 2, 15 ) )

print NetPresentValueOnDates( f( ), DecimalParse( "0.09" ).Value( ), _
                              DAYCOUNT_ACTUAL_365_FIXED ).Value( ).ToStringFixed( 6 )

'' THE BASIS CHANGES THE ANSWER, and is a parameter rather than a
'' hardcoded Act/365 the way Excel's XNPV is.
print NetPresentValueOnDates( f( ), DecimalParse( "0.09" ).Value( ), _
                              DAYCOUNT_ACTUAL_360 ).Value( ).ToStringFixed( 6 )
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincash.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
