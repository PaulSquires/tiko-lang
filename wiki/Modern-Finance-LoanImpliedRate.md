[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanImpliedRate**

# LoanImpliedRate

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LoanImpliedRate( principal, payment, termMonths, paymentFrequency, compounding )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The rate a known payment implies -- the phase-3 root finder reaching
'' this surface.  Returns the NOMINAL ANNUAL rate at the given
'' compounding, so it is comparable with the quoted rate.
dim as Decimal p = DecimalParse( "400000" ).Value( )
dim as Decimal pmt = DecimalParse( "2385.36" ).Value( )

var r = LoanImpliedRate( p, pmt, 360, PAY_MONTHLY, COMPOUND_MONTHLY )
print r.Value( ).ToStringFixed( 6 )      '' 0.059500

'' It recovers the quoted rate to four places, not twelve -- the payment
'' it was given had already been ROUNDED TO CENTS, so the rate implied by
'' 2385.36 differs slightly from the one that produced it.
print r.Value( ).Round( 4 ).ToString( )  '' 0.0595
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
