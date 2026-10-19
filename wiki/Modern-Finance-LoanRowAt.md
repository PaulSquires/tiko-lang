[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanRowAt**

# LoanRowAt

Returns one row of a loan schedule, rounded exactly as it would be posted.

## Syntax

```freebasic
LoanRowAt( loanTerms, period )
```

## Examples

```freebasic
#import "std/money"
using money

'' One row of the schedule.  It WALKS, and is therefore AUTHORITATIVE --
'' the sum of what would actually be posted, rounding and all.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

print LoanRowAt( t, 1 ).Value( ).Interest_.ToStringFixed( 2 )       '' 1983.33
print LoanRowAt( t, 180 ).Value( ).ClosingBalance_.ToStringFixed( 2 )  '' 283580.13

'' The LAST payment differs from the scheduled one -- it absorbs the
'' rounding residue so the balance lands on exactly zero.
dim as AmortizationRow last_ = LoanRowAt( t, 360 ).Value( )
print last_.Payment_.ToStringFixed( 2 )  '' 2384.39
print last_.IsFinal_                     '' true
print last_.ClosingBalance_.IsZero( )    '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finloan.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
