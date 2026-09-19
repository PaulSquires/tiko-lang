[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **SolveRatePerPeriod**

# SolveRatePerPeriod

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
SolveRatePerPeriod( annuityTerms )
SolveRatePerPeriod( annuityTerms, solverOptions )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The rate implied by a known payment -- the one function on this
'' surface that iterates, because there is no closed form for i.
dim as Decimal i = RatePerPeriod( DecimalParse( "0.0595" ).Value( ), COMPOUND_MONTHLY ).Value( )

dim as AnnuityTerms m = AnnuityTermsMake( i, 360, DecimalZero( ), _
                                          DecimalParse( "400000" ).Value( ), _
                                          DecimalZero( ), PAY_END_OF_PERIOD )
dim as Decimal pmt = PaymentAmount( m ).Value( )

'' Feed the payment back and the rate comes out again.
dim as AnnuityTerms back = AnnuityTermsMake( DecimalZero( ), 360, pmt, _
                                             DecimalParse( "400000" ).Value( ), _
                                             DecimalZero( ), PAY_END_OF_PERIOD )
print ( SolveRatePerPeriod( back ).Value( ).Round( 12 ) = i.Round( 12 ) )    '' true

'' A 0% loan solves to EXACTLY zero rather than to something tiny.
dim as AnnuityTerms z = AnnuityTermsMake( DecimalZero( ), 24, _
                                          DecimalParse( "-100" ).Value( ), _
                                          DecimalParse( "2400" ).Value( ), _
                                          DecimalZero( ), PAY_END_OF_PERIOD )
print SolveRatePerPeriod( z ).Value( ).IsZero( )                             '' true
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fintvm.bi` in the tiko-lang repository.
