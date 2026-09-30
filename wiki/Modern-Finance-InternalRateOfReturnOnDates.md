[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **InternalRateOfReturnOnDates**

# InternalRateOfReturnOnDates

## Syntax

```freebasic
InternalRateOfReturnOnDates( flows( ), basis )
InternalRateOfReturnOnDates( flows( ), basis, solverOptions )
```

## Examples

```freebasic
#import "std/money"
using FB

'' IRR over irregular dates -- the equivalent of a spreadsheet's XIRR,
'' except the day-count basis is yours to choose.
dim as CashFlow f( 0 to 3 )
f( 0 ) = CashFlowMake( DecimalParse( "-10000" ).Value( ), LocalDate( 2026, 1, 1 ) )
f( 1 ) = CashFlowMake( DecimalParse( "2750" ).Value( ),   LocalDate( 2026, 3, 1 ) )
f( 2 ) = CashFlowMake( DecimalParse( "4250" ).Value( ),   LocalDate( 2026, 10, 30 ) )
f( 3 ) = CashFlowMake( DecimalParse( "3250" ).Value( ),   LocalDate( 2027, 2, 15 ) )

var r = InternalRateOfReturnOnDates( f( ), DAYCOUNT_ACTUAL_365_FIXED )
print r.Value( ).ToStringFixed( 10 )

'' Checked by substitution: the dated NPV at that rate is zero.
print NetPresentValueOnDates( f( ), r.Value( ), _
                              DAYCOUNT_ACTUAL_365_FIXED ).Value( ).ToStringFixed( 6 )
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincash.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
