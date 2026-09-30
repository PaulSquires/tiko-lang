[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanSummarize**

# LoanSummarize

## Syntax

```freebasic
LoanSummarize( loanTerms )
LoanSummarize( loanTerms, extras( ) )
```

## Examples

```freebasic
#import "std/money"
using FB

'' The whole loan in one record: what it costs, how long it runs, and --
'' with extras -- what they saved.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

var s = LoanSummarize( t )

print s.Value( ).ScheduledPayment_.ToStringFixed( 2 )    '' 2385.36
print s.Value( ).FinalPayment_.ToStringFixed( 2 )        '' 2384.39
print s.Value( ).PaymentCount_                           '' 360
print s.Value( ).TotalInterest_.ToStringFixed( 2 )       '' 458728.63
print s.Value( ).TotalPaid_.ToStringFixed( 2 )           '' 858728.63

'' Total paid is interest plus principal, exactly.
print ( s.Value( ).TotalPaid_ = _
        ( s.Value( ).TotalInterest_ + s.Value( ).TotalPrincipal_ ) )   '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
