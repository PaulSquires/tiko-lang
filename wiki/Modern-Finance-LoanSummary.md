[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanSummary**

# LoanSummary

## Syntax

```freebasic
s.ScheduledPayment_  s.FinalPayment_  s.PaymentCount_  s.TotalPaid_  s.TotalInterest_  s.TotalPrincipal_  s.EffectiveAnnualRate_  s.InterestSavedVsScheduled_  s.PeriodsSaved_  s.PayoffDate_
```

## Examples

```freebasic
#import "std/money"
using money

'' What LoanSummarize returns.  The last three fields are the ones that
'' only mean something when extra payments were supplied.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

dim as ExtraPayment ex( 0 to 0 )
ex( 0 ) = ExtraPaymentRecurring( 1, 360, DecimalParse( "200" ).Value( ) )

var plain = LoanSummarize( t )
var early = LoanSummarize( t, ex( ) )

print plain.Value( ).PeriodsSaved_                       '' 0
print early.Value( ).PaymentCount_                       '' 295
print early.Value( ).PeriodsSaved_                       '' 65
print early.Value( ).InterestSavedVsScheduled_.ToStringFixed( 2 )   '' 96974.24
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finloan.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
