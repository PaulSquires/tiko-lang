[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **CompoundAnnualGrowthRate**

# CompoundAnnualGrowthRate

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
CompoundAnnualGrowthRate( beginValue, endValue, years )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The single annual rate that turns the opening value into the closing
'' one over the term -- a fractional root, so the double kernel.
var c = CompoundAnnualGrowthRate( DecimalParse( "1000" ).Value( ), _
                                  DecimalParse( "2000" ).Value( ), 5.0 )
print c.Value( )                         '' 0.148698354997035

'' Its definition, checked by substitution: growing at that rate for the
'' whole term reproduces the ending value.
print 1000.0 * ( ( 1.0 + c.Value( ) ) ^ 5.0 )            '' 1999.999999999999 -- 2000, to double precision

'' A zero or negative starting value has no growth rate.
print CompoundAnnualGrowthRate( DecimalZero( ), DecimalFromInt( 10 ), 5.0 ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finport.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
