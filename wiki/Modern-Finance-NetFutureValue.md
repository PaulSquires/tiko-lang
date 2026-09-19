[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **NetFutureValue**

# NetFutureValue

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
NetFutureValue( flows( ), ratePerPeriod )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The net present value carried forward to the end of the series.
dim as Decimal f( 0 to 4 ) = { DecimalParse( "-1000" ).Value( ), _
                               DecimalParse( "300" ).Value( ), _
                               DecimalParse( "400" ).Value( ), _
                               DecimalParse( "500" ).Value( ), _
                               DecimalParse( "200" ).Value( ) }

print NetFutureValue( f( ), DecimalParse( "0.10" ).Value( ) ).Value( ).ToStringFixed( 4 )    '' 169.2000

'' It is the NPV grown over the term, which is the relationship that
'' keeps the two consistent.
dim as Decimal npv = NetPresentValue( f( ), DecimalParse( "0.10" ).Value( ) ).Value( )
dim as Decimal g = GrowthFactor( DecimalParse( "0.10" ).Value( ), 4 ).Value( )
print ( npv * g ).ToStringFixed( 4 )                                                          '' 169.2000
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincash.bi` in the tiko-lang repository.
