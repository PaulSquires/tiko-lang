[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DepreciationScheduleOf**

# DepreciationScheduleOf

## Syntax

```freebasic
DepreciationScheduleOf( terms, method )
```

## Examples

```freebasic
#import "std/money"
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

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/findeprec.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
