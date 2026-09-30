[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DepreciationScheduleIterator**

# DepreciationScheduleIterator

## Syntax

```freebasic
it.IsValid( )  it.Value( )  it.MoveNext( )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The iterator protocol behind FOR EACH -- walk it by hand to stop
'' early or inspect a window.
dim as DepreciationTerms t = DepreciationTermsMake( DecimalParse( "50000" ).Value( ), _
                                                    DecimalParse( "5000" ).Value( ), 7 )

var s = DepreciationScheduleOf( t, DEPRECIATION_SUM_OF_YEARS_DIGITS )
var it = s.Value( ).GetIterator( )

dim as long k = 0
while( it.IsValid( ) andalso ( k < 3 ) )
    print it.Value( ).Period_; " "; it.Value( ).Expense_.ToStringFixed( 2 )
    it.MoveNext( )
    k += 1
wend
print k                                  '' 3
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/findeprec.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
