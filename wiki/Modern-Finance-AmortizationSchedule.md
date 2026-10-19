[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **AmortizationSchedule**

# AmortizationSchedule

Holds a loan schedule's terms and gives its scheduled payment count and payment.

## Syntax

```freebasic
s.GetIterator( )  s.Count( )  s.Payment( )
```

## Examples

```freebasic
#import "std/money"
using money

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
**Source:** `pkg/std/money/finloan.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
