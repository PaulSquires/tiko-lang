[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **CashFlowMake**

# CashFlowMake

## Syntax

```freebasic
CashFlowMake( amount, date )
```

## Examples

```freebasic
#import "std/chrono"
#import "std/money"
using money, chrono

'' Construction by named free function, as everywhere else in the module.
dim as CashFlow f( 0 to 2 )
f( 0 ) = CashFlowMake( DecimalParse( "-10000" ).Value( ), LocalDate( 2026, 1, 1 ) )
f( 1 ) = CashFlowMake( DecimalParse( "4000" ).Value( ),  LocalDate( 2026, 7, 1 ) )
f( 2 ) = CashFlowMake( DecimalParse( "7000" ).Value( ),  LocalDate( 2027, 1, 1 ) )

print InternalRateOfReturnOnDates( f( ), DAYCOUNT_ACTUAL_365_FIXED ).Value( ).ToStringFixed( 6 )

'' THE DATES MUST ASCEND -- a reversed or duplicated date is refused
'' rather than silently sorted.
print NetPresentValueOnDates( f( ), DecimalParse( "0.08" ).Value( ), _
                              DAYCOUNT_ACTUAL_365_FIXED ).Value( ).ToStringFixed( 2 )
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincash.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
