[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **ScheduleToArray**

# ScheduleToArray

Returns every row of a loan schedule as an Array, for random access.

## Syntax

```freebasic
ScheduleToArray( amortizationSchedule )
```

## Examples

```freebasic
#import "std/containers"
#import "std/money"
using money, containers

'' Materialize the whole schedule when you genuinely want random access.
'' The lazy walk is the default because it allocates nothing.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

var sched = LoanSchedule( t )
dim as Array( of AmortizationRow ) rows = ScheduleToArray( sched.Value( ) )

print rows.Count( )                      '' 360
print rows.At( 0 ).Period_               '' 1
print rows.At( 0 ).ClosingBalance_.ToStringFixed( 2 )    '' 399597.97
print rows.At( 359 ).IsFinal_            '' true
print rows.At( 359 ).ClosingBalance_.IsZero( )           '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finloan.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
