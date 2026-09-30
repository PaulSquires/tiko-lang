[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **CashFlowAt**

# CashFlowAt

## Syntax

```freebasic
CashFlowAt( amount, period )
```

## Examples

```freebasic
#import "std/money"
using FB

'' A period-indexed flow: Date_ is Invalid, deliberately, because the
'' POSITION in the caller's array already carries the period.  The
'' 'period' argument is for readability at the call site.
dim as CashFlow c = CashFlowAt( DecimalParse( "-1000" ).Value( ), 0 )

print c.Amount_.ToString( )              '' -1000
print c.Date_.IsValid                    '' false

'' Handing one to a DATED function is a named refusal rather than a
'' silent treatment of day zero.
dim as CashFlow f( 0 to 1 )
f( 0 ) = CashFlowAt( DecimalParse( "-100" ).Value( ), 0 )
f( 1 ) = CashFlowAt( DecimalParse( "200" ).Value( ), 1 )
print InternalRateOfReturnOnDates( f( ), DAYCOUNT_ACTUAL_365_FIXED ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincash.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
