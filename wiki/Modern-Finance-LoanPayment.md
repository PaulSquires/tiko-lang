[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanPayment**

# LoanPayment

## Syntax

```freebasic
LoanPayment( loanTerms )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The level payment, computed unrounded then ROUNDED EXACTLY ONCE -- and
'' deliberately not rounded up "to be safe", because rounding up
'' overcharges systematically over 360 periods.  The residue is absorbed
'' by the final payment instead.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

print LoanPayment( t ).Value( ).ToStringFixed( 2 )       '' 2385.36

'' A 0% loan divides the principal evenly, exactly.
dim as LoanTerms z = LoanTermsMake( DecimalParse( "2400" ).Value( ), DecimalZero( ), _
                                    24, PAY_MONTHLY, COMPOUND_MONTHLY )
print LoanPayment( z ).Value( ).ToString( )              '' 100
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
