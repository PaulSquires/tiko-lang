[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanPrincipalBetween**

# LoanPrincipalBetween

## Syntax

```freebasic
LoanPrincipalBetween( loanTerms, fromPeriod, toPeriod )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Principal retired across a range -- including any extra payments made
'' in it.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

print LoanPrincipalBetween( t, 1, 12 ).Value( ).ToStringFixed( 2 )     '' 4958.09

'' Over the whole term it is exactly the loan.
print LoanPrincipalBetween( t, 1, 360 ).Value( ).ToString( )           '' 400000.00

'' Early payments are mostly interest; late ones mostly principal.
dim as boolean laterIsMore = ( LoanPrincipalBetween( t, 349, 360 ).Value( ) > _
                               LoanPrincipalBetween( t, 1, 12 ).Value( ) )
print laterIsMore                        '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
