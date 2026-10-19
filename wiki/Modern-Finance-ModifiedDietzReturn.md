[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **ModifiedDietzReturn**

# ModifiedDietzReturn

Returns an approximate time-weighted return, weighting each flow by days invested.

## Syntax

```freebasic
ModifiedDietzReturn( beginValue, endValue, flows( ), flowDayOffsets( ), periodDays )
```

## Examples

```freebasic
#import "std/money"
using money

'' The standard approximation to a time-weighted return when you cannot
'' value the portfolio at every flow: each flow is weighted by the
'' fraction of the period it was invested for.
dim as Decimal fl( 0 to 0 ) = { DecimalParse( "10000" ).Value( ) }
dim as int32 off( 0 to 0 ) = { 45 }

'' 100,000 grows to 112,000 with a 10,000 contribution on day 45 of 90,
'' so the denominator is 100,000 + half of 10,000.
print ModifiedDietzReturn( DecimalParse( "100000" ).Value( ), _
                           DecimalParse( "112000" ).Value( ), _
                           fl( ), off( ), 90 ).Value( )   '' 0.01904761904761905

'' A flow on the FIRST day is fully weighted, one on the LAST day not at
'' all -- which is the whole point of the weighting.
dim as int32 first_( 0 to 0 ) = { 0 }
print ModifiedDietzReturn( DecimalParse( "100000" ).Value( ), _
                           DecimalParse( "112000" ).Value( ), _
                           fl( ), first_( ), 90 ).Value( )
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finport.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
