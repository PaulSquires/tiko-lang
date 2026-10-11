[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **AmortizationIterator**

# AmortizationIterator

## Syntax

```freebasic
it.IsValid( )  it.Value( )  it.MoveNext( )
```

## Examples

```freebasic
#import "std/money"
using money

'' The structural iterator protocol, which is what FOR EACH uses.  Walk
'' it by hand when you want to stop early or look at a window.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

var sched = LoanSchedule( t )
var it = sched.Value( ).GetIterator( )

'' The first three rows.
dim as int32 k = 0
while( it.IsValid( ) andalso ( k < 3 ) )
    print it.Value( ).Period_; " "; it.Value( ).Interest_.ToStringFixed( 2 )
    it.MoveNext( )
    k += 1
wend

'' NO DESTRUCTOR is needed -- unlike std/fs's directory iterator,
'' this one holds no handle, so stopping here leaks nothing.
print k                                  '' 3
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finloan.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
