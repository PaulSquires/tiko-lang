[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **AmortizationSchedule**

# AmortizationSchedule

## Syntax

```freebasic
s.GetIterator( )  s.Count( )  s.Payment( )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Holds the terms, not the rows.  Count( ) is the SCHEDULED number of
'' payments; extra payments can end the loan sooner, and LoanSummarize
'' reports what was actually posted.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

var sched = LoanSchedule( t )

print sched.Value( ).Count( )            '' 360
print sched.Value( ).Payment( ).ToStringFixed( 2 )       '' 2385.36

'' Two independent walks give the same rows -- there is no consumed
'' state to exhaust.
var a = sched.Value( ).GetIterator( )
var b = sched.Value( ).GetIterator( )
print a.Value( ).Period_                 '' 1
print b.Value( ).Period_                 '' 1
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
