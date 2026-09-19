[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DepreciationRow**

# DepreciationRow

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
row.Period_  row.OpeningBookValue_  row.Expense_  row.AccumulatedDepreciation_  row.ClosingBookValue_  row.SwitchedToStraightLine_
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' One period of a schedule.  SwitchedToStraightLine_ latches from the
'' period the switch happens and stays set.
dim as DepreciationTerms t = DepreciationTermsMake( DecimalParse( "50000" ).Value( ), _
                                                    DecimalParse( "5000" ).Value( ), 7 )

var s = DepreciationScheduleOf( t, DEPRECIATION_STRAIGHT_LINE )

for each row in s.Value( )
    if( row.Period_ <= 2 ) then
        print row.Period_; " "; row.Expense_.ToStringFixed( 2 ); _
              " "; row.ClosingBookValue_.ToStringFixed( 2 )
    end if
next

'' The last row leaves the book value at EXACTLY salvage.
dim as Array( of DepreciationRow ) rows = DepreciationScheduleToArray( s.Value( ) )
print ( rows.At( 6 ).ClosingBookValue_ = t.Salvage_ )    '' true
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/findeprec.bi` in the tiko-lang repository.
