[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **AnnuityPresentValueFactor**

# AnnuityPresentValueFactor

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
AnnuityPresentValueFactor( ratePerPeriod, periods, timing )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' ( 1 - v^n ) / i -- what one unit per period is worth today.  Exposed
'' because it is the reusable piece the value functions are built from.
dim as Decimal i = DecimalParse( "0.10" ).Value( )

print AnnuityPresentValueFactor( i, 10, PAY_END_OF_PERIOD ).Value( ).ToStringFixed( 8 )  '' 6.14456711

'' AT A ZERO RATE THE LIMIT IS n, returned by an explicit test rather
'' than reached through a division by zero -- which is where most
'' time-value libraries return Invalid.
print AnnuityPresentValueFactor( DecimalZero( ), 10, PAY_END_OF_PERIOD ).Value( ).ToString( )   '' 10

'' No payments, no value.
print AnnuityPresentValueFactor( i, 0, PAY_END_OF_PERIOD ).Value( ).IsZero( )   '' true
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fintvm.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
