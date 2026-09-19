[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **CashFlow**

# CashFlow

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
c.Amount_  c.Date_
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' An amount and the date it happens.  The dated NPV and IRR take these;
'' the periodic forms take a plain Decimal array instead.
dim as CashFlow c = CashFlowMake( DecimalParse( "-10000" ).Value( ), _
                                  LocalDate( 2026, 1, 1 ) )

print c.Amount_.ToString( )              '' -10000
print c.Date_.Year                       '' 2026
print c.Date_.IsValid                    '' true

'' CashFlowAt carries no date, for the period-indexed API -- and a dated
'' function refuses it rather than inventing a calendar.
dim as CashFlow p = CashFlowAt( DecimalParse( "500" ).Value( ), 3 )
print p.Date_.IsValid                    '' false
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincash.bi` in the tiko-lang repository.
