[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanTermsUsMortgage**

# LoanTermsUsMortgage

Returns loan terms for a US mortgage: monthly compounding and monthly payments.

## Syntax

```freebasic
LoanTermsUsMortgage( principal, nominalAnnualRate, termYears )
```

## Examples

```freebasic
#import "std/money"
using money

'' The US convention: interest compounds MONTHLY and payments are
'' monthly, so the two frequencies collapse and the rate per payment is
'' exactly the quoted rate over twelve.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

print LoanPayment( t ).Value( ).ToStringFixed( 2 )       '' 2385.36

'' The first period's interest is simply 400000 * 0.0595/12.
print LoanRowAt( t, 1 ).Value( ).Interest_.ToStringFixed( 2 )   '' 1983.33
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finloan.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
