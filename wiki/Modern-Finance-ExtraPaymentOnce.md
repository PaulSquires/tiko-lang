[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **ExtraPaymentOnce**

# ExtraPaymentOnce

## Syntax

```freebasic
ExtraPaymentOnce( period, amount )
```

## Examples

```freebasic
#import "std/money"
using FB

'' A single lump prepayment.  It applies AFTER the scheduled split, so
'' the period's interest and principal are unchanged -- only the closing
'' balance moves.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

dim as ExtraPayment ex( 0 to 0 )
ex( 0 ) = ExtraPaymentOnce( 12, DecimalParse( "50000" ).Value( ) )

var s = LoanSummarize( t, ex( ) )
print s.Value( ).PaymentCount_           '' 268 -- 92 periods earlier
print s.Value( ).PeriodsSaved_           '' 92
print s.Value( ).TotalInterest_.ToStringFixed( 2 )       '' 287781.06
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
