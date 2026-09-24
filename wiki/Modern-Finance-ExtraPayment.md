[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **ExtraPayment**

# ExtraPayment

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
x.FromPeriod_  x.ToPeriod_  x.Amount_
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Extra principal applied over a range of periods.  Overlapping ranges
'' ADD, so a recurring extra plus a one-off both land in the same period.
dim as ExtraPayment monthly = ExtraPaymentRecurring( 1, 60, DecimalParse( "100" ).Value( ) )
dim as ExtraPayment bonus = ExtraPaymentOnce( 36, DecimalParse( "5000" ).Value( ) )

print monthly.FromPeriod_                '' 1
print monthly.ToPeriod_                  '' 60
print bonus.FromPeriod_                  '' 36
print bonus.ToPeriod_                    '' 36 -- a one-off is a range of one
print bonus.Amount_.ToString( )          '' 5000
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
