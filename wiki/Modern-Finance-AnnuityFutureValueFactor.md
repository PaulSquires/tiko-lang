[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **AnnuityFutureValueFactor**

# AnnuityFutureValueFactor

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
AnnuityFutureValueFactor( ratePerPeriod, periods, timing )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' ( (1+i)^n - 1 ) / i -- what one unit per period grows to by the end.
dim as Decimal i = DecimalParse( "0.10" ).Value( )

'' This one terminates, so it is exact.
print AnnuityFutureValueFactor( i, 10, PAY_END_OF_PERIOD ).Value( ).ToStringFixed( 9 )   '' 15.937424601

'' The two factors are related by the growth factor, which is what keeps
'' PresentValue and FutureValue consistent with each other.
dim as Decimal a = AnnuityPresentValueFactor( i, 10, PAY_END_OF_PERIOD ).Value( )
dim as Decimal g = GrowthFactor( i, 10 ).Value( )
print ( a * g ).Round( 18 ).ToStringFixed( 6 )                                    '' 15.937425

'' Same zero-rate limit.
print AnnuityFutureValueFactor( DecimalZero( ), 10, PAY_END_OF_PERIOD ).Value( ).ToString( )   '' 10
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fintvm.bi` in the tiko-lang repository.
