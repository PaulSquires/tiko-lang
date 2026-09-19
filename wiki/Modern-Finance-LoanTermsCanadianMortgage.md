[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanTermsCanadianMortgage**

# LoanTermsCanadianMortgage

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LoanTermsCanadianMortgage( principal, nominalAnnualRate, amortizationYears )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The Canadian convention: the Interest Act requires a mortgage rate to
'' be quoted SEMI-ANNUALLY, NOT IN ADVANCE, while payments stay monthly.
'' ONE ENUM different from the US form -- and worth real money.
dim as Decimal p = DecimalParse( "400000" ).Value( )
dim as Decimal r = DecimalParse( "0.0595" ).Value( )

dim as LoanTerms ca = LoanTermsCanadianMortgage( p, r, 25 )
dim as LoanTerms us = LoanTermsUsMortgage( p, r, 25 )

print LoanPayment( ca ).Value( ).ToStringFixed( 2 )      '' 2547.35
print LoanPayment( us ).Value( ).ToStringFixed( 2 )      '' 2564.99

'' 17.64 a month, about 5,292 over the term.  A library that ignored the
'' compounding parameter would quietly return the US figure.
print ( LoanPayment( us ).Value( ) - LoanPayment( ca ).Value( ) ).ToStringFixed( 2 )   '' 17.64
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the tiko-lang repository.
