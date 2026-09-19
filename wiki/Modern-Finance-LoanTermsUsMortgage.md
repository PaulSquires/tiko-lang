[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanTermsUsMortgage**

# LoanTermsUsMortgage

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LoanTermsUsMortgage( principal, nominalAnnualRate, termYears )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

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

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the tiko-lang repository.
