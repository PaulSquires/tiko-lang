[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MoneyWeightedReturn**

# MoneyWeightedReturn

## Syntax

```freebasic
MoneyWeightedReturn( flows( ), terminalValue, terminalDate, basis )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The dated internal rate of return of the contributions, with the
'' closing value appended.  It measures the INVESTOR -- unlike a
'' time-weighted return, it DOES reflect when money went in.
dim as CashFlow f( 0 to 1 )
f( 0 ) = CashFlowMake( DecimalParse( "-10000" ).Value( ), LocalDate( 2026, 1, 1 ) )
f( 1 ) = CashFlowMake( DecimalParse( "-5000" ).Value( ),  LocalDate( 2026, 7, 1 ) )

var m = MoneyWeightedReturn( f( ), DecimalParse( "16500" ).Value( ), _
                             LocalDate( 2027, 1, 1 ), DAYCOUNT_ACTUAL_365_FIXED )
print m.IsOk( )                          '' true
print ( m.Value( ) > 0.0 )               '' -1 (an integer comparison)

'' An invalid terminal date is refused rather than guessed at.
print MoneyWeightedReturn( f( ), DecimalParse( "16500" ).Value( ), _
                           LocalDate.Invalid( ), _
                           DAYCOUNT_ACTUAL_365_FIXED ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finport.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
