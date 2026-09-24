[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DepreciationSchedule**

# DepreciationSchedule

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
s.GetIterator( )  s.Count( )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The whole write-off, period by period.  Unlike the loan schedule this
'' one MATERIALIZES its rows, because the last period clears the
'' remainder by assignment and so depends on every row before it.
dim as DepreciationTerms t = DepreciationTermsMake( DecimalParse( "50000" ).Value( ), _
                                                    DecimalParse( "5000" ).Value( ), 7 )

var s = DepreciationScheduleOf( t, DEPRECIATION_DOUBLE_DECLINING )
print s.Value( ).Count( )                '' 7

dim as Decimal total = DecimalZero( )
for each row in s.Value( )
    total = total + row.Expense_
next
print total.ToStringFixed( 2 )           '' 45000.00 -- exactly the base
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/findeprec.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
