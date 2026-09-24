[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **ScheduleToArray**

# ScheduleToArray

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
ScheduleToArray( amortizationSchedule )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Materialize the whole schedule when you genuinely want random access.
'' The lazy walk is the default because it allocates nothing.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

var sched = LoanSchedule( t )
dim as Array( of AmortizationRow ) rows = ScheduleToArray( sched.Value( ) )

print rows.Count( )                      '' 360
print rows.At( 0 ).Period_               '' 1
print rows.At( 0 ).ClosingBalance_.ToStringFixed( 2 )    '' 399597.97
print rows.At( 359 ).IsFinal_            '' true
print rows.At( 359 ).ClosingBalance_.IsZero( )           '' true
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
