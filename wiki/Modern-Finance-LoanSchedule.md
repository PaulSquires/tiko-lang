[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanSchedule**

# LoanSchedule

Returns a loan's amortization schedule, built lazily, to walk with for each.

## Syntax

```freebasic
LoanSchedule( loanTerms )
LoanSchedule( loanTerms, extras( ) )
```

## Examples

```freebasic
#import "std/money"
using money

'' The amortization schedule -- LAZY, holding the terms rather than the
'' rows, so a 360-period mortgage costs one record and not 360.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

var sched = LoanSchedule( t )
print sched.Value( ).Count( )            '' 360
print sched.Value( ).Payment( ).ToStringFixed( 2 )       '' 2385.36

'' Walk it with FOR EACH; the iterator owns no resource, so abandoning
'' the loop early leaks nothing.
dim as int32 n = 0
dim as Decimal lastBalance = DecimalZero( )
for each row in sched.Value( )
    n += 1
    lastBalance = row.ClosingBalance_
next
print n                                  '' 360
print lastBalance.IsZero( )              '' true -- EXACTLY zero
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finloan.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
