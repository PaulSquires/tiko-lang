[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DepreciationRow**

# DepreciationRow

## Syntax

```freebasic
row.Period_  row.OpeningBookValue_  row.Expense_  row.AccumulatedDepreciation_  row.ClosingBookValue_  row.SwitchedToStraightLine_
```

## Examples

```freebasic
#import "std/containers"
#import "std/money"
using money, containers

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

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/findeprec.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
