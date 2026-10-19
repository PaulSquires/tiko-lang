[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DepreciationScheduleToArray**

# DepreciationScheduleToArray

Returns every row of a depreciation schedule as an Array.

## Syntax

```freebasic
DepreciationScheduleToArray( depreciationSchedule )
```

## Examples

```freebasic
#import "std/containers"
#import "std/money"
using money, containers

'' The schedule as an array, for random access.
dim as DepreciationTerms t = DepreciationTermsMake( DecimalParse( "50000" ).Value( ), _
                                                    DecimalParse( "5000" ).Value( ), 7 )

var s = DepreciationScheduleOf( t, DEPRECIATION_STRAIGHT_LINE )
dim as Array( of DepreciationRow ) rows = DepreciationScheduleToArray( s.Value( ) )

print rows.Count( )                      '' 7
print rows.At( 0 ).Period_               '' 1
print rows.At( 0 ).Expense_.ToStringFixed( 2 )           '' 6428.57

'' The book value lands on EXACTLY salvage, compared with '=' rather
'' than a tolerance.
print ( rows.At( 6 ).ClosingBookValue_ = t.Salvage_ )    '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/findeprec.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
