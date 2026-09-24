[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **Compounding**

# Compounding

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
COMPOUND_ANNUAL  COMPOUND_SEMIANNUAL  COMPOUND_MONTHLY  COMPOUND_CONTINUOUS  COMPOUND_SIMPLE  ...
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' THE VALUES ARE PERIODS PER YEAR, so converting a rate is a division
'' rather than a lookup table.
print COMPOUND_MONTHLY                   '' 12
print COMPOUND_SEMIANNUAL                '' 2

'' Two members are NOT frequencies, and every function branches on them
'' explicitly rather than dividing by zero.
print COMPOUND_SIMPLE                    '' 0
print COMPOUND_CONTINUOUS                '' -1

'' Compounding is what makes a Canadian mortgage differ from a US one on
'' the same quoted rate -- see RatePerPaymentFromNominal.
dim as Decimal j = DecimalParse( "0.0595" ).Value( )
print RateEffectiveFromNominal( j, COMPOUND_SEMIANNUAL ).Value( ).ToString( )
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
