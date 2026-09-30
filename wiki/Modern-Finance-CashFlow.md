[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **CashFlow**

# CashFlow

## Syntax

```freebasic
c.Amount_  c.Date_
```

## Examples

```freebasic
#import "std/money"
using FB

'' An amount and the date it happens.  The dated NPV and IRR take these;
'' the periodic forms take a plain Decimal array instead.
dim as CashFlow c = CashFlowMake( DecimalParse( "-10000" ).Value( ), _
                                  LocalDate( 2026, 1, 1 ) )

print c.Amount_.ToString( )              '' -10000
print c.Date_.Year                       '' 2026
print c.Date_.IsValid                    '' true

'' CashFlowAt carries no date, for the period-indexed API -- and a dated
'' function refuses it rather than inventing a calendar.
dim as CashFlow p = CashFlowAt( DecimalParse( "500" ).Value( ), 3 )
print p.Date_.IsValid                    '' false
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincash.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
