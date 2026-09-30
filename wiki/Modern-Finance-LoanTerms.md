[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanTerms**

# LoanTerms

## Syntax

```freebasic
t.Principal_  t.NominalAnnualRate_  t.Compounding_  t.PaymentFrequency_  t.TermMonths_  t.Timing_  t.BalloonAmount_  t.Rounding_  t.FirstPaymentDate_  t.Basis_
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Everything a schedule needs, in one record.  COMPOUNDING AND PAYMENT
'' FREQUENCY ARE SEPARATE FIELDS, which is what lets one code path serve
'' both the US and Canadian mortgage conventions.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

print t.TermMonths_                      '' 360
print t.Principal_.ToString( )           '' 400000
print t.Rounding_.Digits_                '' 2 -- cents, by default

'' The Canadian form is THE SAME RECORD with one field changed.
dim as LoanTerms ca = LoanTermsCanadianMortgage( DecimalParse( "400000" ).Value( ), _
                                                 DecimalParse( "0.0595" ).Value( ), 30 )
dim as boolean sameTerm = ( ca.TermMonths_ = t.TermMonths_ )
dim as boolean diffCompounding = ( ca.Compounding_ <> t.Compounding_ )
print sameTerm                           '' true
print diffCompounding                    '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
