[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **RateNominalFromEffective**

# RateNominalFromEffective

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
RateNominalFromEffective( effectiveAnnual, compounding )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The inverse of RateEffectiveFromNominal: the rate you would have to
'' quote to earn a given effective return.  Double kernel -- a root.
dim as Decimal eff = DecimalParse( "0.0603850625" ).Value( )

print RateNominalFromEffective( eff, COMPOUND_SEMIANNUAL ).Value( ).ToStringFixed( 6 )  '' 0.059500

'' Round trip: nominal -> effective -> nominal recovers the input.
dim as Decimal j = DecimalParse( "0.0595" ).Value( )
dim as Decimal e2 = RateEffectiveFromNominal( j, COMPOUND_MONTHLY ).Value( )
print RateNominalFromEffective( e2, COMPOUND_MONTHLY ).Value( ).Round( 12 ).ToString( )
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the tiko-lang repository.
