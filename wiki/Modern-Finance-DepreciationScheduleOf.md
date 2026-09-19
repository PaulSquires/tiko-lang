[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DepreciationScheduleOf**

# DepreciationScheduleOf

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DepreciationScheduleOf( terms, method )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Builds the schedule for a method.  This is the ONLY way to reach
'' DOUBLE_DECLINING_WITH_SWITCH, because the switch is path-dependent:
'' whether period 4 has switched depends on periods 1 to 3.
dim as DepreciationTerms t = DepreciationTermsMake( DecimalParse( "100" ).Value( ), _
                                                    DecimalZero( ), 5 )

var s = DepreciationScheduleOf( t, DEPRECIATION_DOUBLE_DECLINING_WITH_SWITCH )

'' THE SWITCH RULE compares declining balance against straight line ON
'' THE REMAINING BASE OVER THE REMAINING LIFE, recomputed each period --
'' not on the original base, which is the classic wrong version.
for each row in s.Value( )
    print row.Period_; " "; row.Expense_.ToStringFixed( 2 ); _
          " "; row.SwitchedToStraightLine_
next
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/findeprec.bi` in the tiko-lang repository.
