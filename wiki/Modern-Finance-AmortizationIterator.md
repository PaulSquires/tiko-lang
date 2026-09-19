[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **AmortizationIterator**

# AmortizationIterator

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
it.IsValid( )  it.Value( )  it.MoveNext( )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The structural iterator protocol, which is what FOR EACH uses.  Walk
'' it by hand when you want to stop early or look at a window.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

var sched = LoanSchedule( t )
var it = sched.Value( ).GetIterator( )

'' The first three rows.
dim as long k = 0
while( it.IsValid( ) andalso ( k < 3 ) )
    print it.Value( ).Period_; " "; it.Value( ).Interest_.ToStringFixed( 2 )
    it.MoveNext( )
    k += 1
wend

'' NO DESTRUCTOR is needed -- unlike fb/fsdir.bi's directory iterator,
'' this one holds no handle, so stopping here leaks nothing.
print k                                  '' 3
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the tiko-lang repository.
