[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **RatePerPaymentFromNominal**

# RatePerPaymentFromNominal

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
RatePerPaymentFromNominal( nominalAnnual, compounding, paymentFrequency )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' THE FUNNEL every loan function goes through, and the reason this
'' module exists.  Compounding and payment frequency are SEPARATE, so
'' one code path serves both mortgage conventions.
dim as Decimal j = DecimalParse( "0.0595" ).Value( )

'' US: compounds monthly, pays monthly -- the two collapse, and the rate
'' is exactly j/12.
var us = RatePerPaymentFromNominal( j, COMPOUND_MONTHLY, PAY_MONTHLY )
print ( us.Value( ) = ( j / DecimalFromInt( 12 ) ) )        '' true

'' CANADA: the Interest Act requires semi-annual quoting, while payments
'' are monthly -- so the rate is ( 1 + j/2 )^(1/6) - 1.  ONE ENUM apart.
var ca = RatePerPaymentFromNominal( j, COMPOUND_SEMIANNUAL, PAY_MONTHLY )
print ca.Value( ).ToStringFixed( 12 )

'' They differ, and on a mortgage that difference is real money.
print ( ca.Value( ) < us.Value( ) )                         '' true
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the tiko-lang repository.
