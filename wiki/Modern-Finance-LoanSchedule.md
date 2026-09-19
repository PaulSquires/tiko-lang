[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanSchedule**

# LoanSchedule

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LoanSchedule( loanTerms )
LoanSchedule( loanTerms, extras( ) )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The amortization schedule -- LAZY, holding the terms rather than the
'' rows, so a 360-period mortgage costs one record and not 360.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

var sched = LoanSchedule( t )
print sched.Value( ).Count( )            '' 360
print sched.Value( ).Payment( ).ToStringFixed( 2 )       '' 2385.36

'' Walk it with FOR EACH; the iterator owns no resource, so abandoning
'' the loop early leaks nothing.
dim as long n = 0
dim as Decimal lastBalance = DecimalZero( )
for each row in sched.Value( )
    n += 1
    lastBalance = row.ClosingBalance_
next
print n                                  '' 360
print lastBalance.IsZero( )              '' true -- EXACTLY zero
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the tiko-lang repository.
