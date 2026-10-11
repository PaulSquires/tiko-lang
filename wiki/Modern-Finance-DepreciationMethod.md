[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DepreciationMethod**

# DepreciationMethod

## Syntax

```freebasic
DEPRECIATION_STRAIGHT_LINE  DEPRECIATION_DECLINING_BALANCE  DEPRECIATION_DOUBLE_DECLINING  DEPRECIATION_DOUBLE_DECLINING_WITH_SWITCH  DEPRECIATION_SUM_OF_YEARS_DIGITS  DEPRECIATION_UNITS_OF_PRODUCTION
```

## Examples

```freebasic
#import "std/money"
using money

'' Six methods.  The first-period expense is the quickest way to see how
'' differently they front-load the write-off.
dim as DepreciationTerms t = DepreciationTermsMake( DecimalParse( "50000" ).Value( ), _
                                                    DecimalParse( "5000" ).Value( ), 7 )

print DepreciationStraightLine( t, 1 ).Value( ).ToStringFixed( 2 )       '' 6428.57
print DepreciationSumOfYearsDigits( t, 1 ).Value( ).ToStringFixed( 2 )   '' 11250.00
print DepreciationDoubleDeclining( t, 1 ).Value( ).ToStringFixed( 2 )    '' 14285.71

'' UNITS_OF_PRODUCTION has NO schedule form -- a schedule would need a
'' per-period units array -- so asking for one is a named refusal.
print DepreciationScheduleOf( t, DEPRECIATION_UNITS_OF_PRODUCTION ).IsOk( )   '' false
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/findeprec.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
