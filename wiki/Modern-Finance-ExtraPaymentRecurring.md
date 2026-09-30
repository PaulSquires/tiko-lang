[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **ExtraPaymentRecurring**

# ExtraPaymentRecurring

## Syntax

```freebasic
ExtraPaymentRecurring( fromPeriod, toPeriod, amount )
```

## Examples

```freebasic
#import "std/money"
using FB

'' The same extra every period across a range.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

dim as ExtraPayment ex( 0 to 0 )
ex( 0 ) = ExtraPaymentRecurring( 1, 360, DecimalParse( "200" ).Value( ) )

var s = LoanSummarize( t, ex( ) )
print s.Value( ).PaymentCount_           '' 295
print s.Value( ).InterestSavedVsScheduled_.ToStringFixed( 2 )   '' 96974.24

'' AN OVERSIZED EXTRA IS CAPPED at what is left, so the loan ends
'' cleanly instead of going negative.
dim as ExtraPayment huge( 0 to 0 )
huge( 0 ) = ExtraPaymentOnce( 3, DecimalParse( "10000000" ).Value( ) )
var quick = LoanSummarize( t, huge( ) )
print quick.Value( ).PaymentCount_       '' 3
print quick.Value( ).TotalPrincipal_.ToString( )         '' 400000.00
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
