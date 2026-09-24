[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **AnnuityTermsMake**

# AnnuityTermsMake

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
AnnuityTermsMake( ratePerPeriod, periods, payment, presentValue, futureValue, timing )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Construction by named free function, never a one-argument constructor
'' -- the same rule fb/decimal.bi follows.
dim as Decimal i = DecimalParse( "0.01" ).Value( )

'' A savings plan: nothing now, 100 a month for 120 months.
dim as AnnuityTerms save_ = AnnuityTermsMake( i, 120, DecimalParse( "-100" ).Value( ), _
                                              DecimalZero( ), DecimalZero( ), _
                                              PAY_END_OF_PERIOD )
print FutureValue( save_ ).Value( ).ToStringFixed( 2 )   '' 23003.87

'' The UNKNOWN field is ignored: PaymentAmount does not read Payment_.
dim as AnnuityTerms loan_ = AnnuityTermsMake( i, 120, DecimalZero( ), _
                                              DecimalParse( "10000" ).Value( ), _
                                              DecimalZero( ), PAY_END_OF_PERIOD )
print PaymentAmount( loan_ ).Value( ).ToStringFixed( 2 )  '' -143.47
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fintvm.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
