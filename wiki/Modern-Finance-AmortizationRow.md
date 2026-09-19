[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **AmortizationRow**

# AmortizationRow

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
row.Period_  row.DueDate_  row.OpeningBalance_  row.Payment_  row.Interest_  row.Principal_  row.ExtraPrincipal_  row.ClosingBalance_  row.CumulativeInterest_  row.CumulativePrincipal_  row.IsFinal_
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' One posted period.  PRINCIPAL IS THE RESIDUAL -- Payment minus
'' Interest -- which is what makes the row add up as an IDENTITY rather
'' than a coincidence that fails on a few rows out of 360.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

dim as AmortizationRow r = LoanRowAt( t, 1 ).Value( )

print r.Period_                          '' 1
print r.OpeningBalance_.ToString( )      '' 400000
print r.Interest_.ToStringFixed( 2 )     '' 1983.33
print r.Principal_.ToStringFixed( 2 )    '' 402.03
print r.ClosingBalance_.ToStringFixed( 2 )   '' 399597.97

'' The identity, on every row.
print ( r.Payment_ = ( r.Interest_ + r.Principal_ ) )    '' true
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the tiko-lang repository.
