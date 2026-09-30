[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanPayoffAmount**

# LoanPayoffAmount

## Syntax

```freebasic
LoanPayoffAmount( loanTerms, afterPeriod, asOf )
```

## Examples

```freebasic
#import "std/money"
using FB

'' What it costs to settle: the balance after a period, plus per-diem
'' interest to the settlement date on the loan's day-count basis.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

t.FirstPaymentDate_ = LocalDate( 2026, 3, 1 )

'' On the due date there is no per diem to add.
print LoanPayoffAmount( t, 12, LocalDate( 2027, 2, 1 ) ).Value( ).ToStringFixed( 2 )   '' 395041.91

'' Forty-two days later, interest has accrued.
print LoanPayoffAmount( t, 12, LocalDate( 2027, 3, 15 ) ).Value( ).ToStringFixed( 2 )  '' 397746.59

'' A date BEFORE the period's due date is refused rather than accruing
'' negative interest.
print LoanPayoffAmount( t, 12, LocalDate( 2026, 12, 1 ) ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
