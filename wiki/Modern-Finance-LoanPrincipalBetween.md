[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanPrincipalBetween**

# LoanPrincipalBetween

Returns the principal repaid across a range of periods, extra payments included.

## Syntax

```freebasic
LoanPrincipalBetween( loanTerms, fromPeriod, toPeriod )
```

## Examples

```freebasic
#import "std/money"
using money

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
**Source:** `pkg/std/money/finloan.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
