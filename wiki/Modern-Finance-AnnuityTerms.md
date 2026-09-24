[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **AnnuityTerms**

# AnnuityTerms

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
t.RatePerPeriod_  t.Periods_  t.Payment_  t.PresentValue_  t.FutureValue_  t.Timing_
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The five quantities of an annuity in one record, so a transposed
'' argument is visible at the call site rather than a plausible wrong
'' number.  Everything in fb/fintvm.bi rearranges
''
''     PV + PMT * a( i, n, timing ) + FV * v( i, n ) = 0
dim as Decimal i = RatePerPeriod( DecimalParse( "0.06" ).Value( ), COMPOUND_MONTHLY ).Value( )

dim as AnnuityTerms t = AnnuityTermsMake( i, 360, DecimalZero( ), _
                                          DecimalParse( "400000" ).Value( ), _
                                          DecimalZero( ), PAY_END_OF_PERIOD )
print t.Periods_                         '' 360
print t.PresentValue_.ToString( )        '' 400000
print PaymentAmount( t ).Value( ).ToStringFixed( 2 )    '' -2398.20
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fintvm.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
