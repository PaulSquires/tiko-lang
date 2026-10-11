[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **HoldingPeriodReturn**

# HoldingPeriodReturn

## Syntax

```freebasic
HoldingPeriodReturn( beginValue, endValue, income )
```

## Examples

```freebasic
#import "std/money"
using money

'' The one EXACT function on this surface -- a single Decimal division of
'' two money amounts, with no root and no summation to lose precision to.
print HoldingPeriodReturn( DecimalParse( "10000" ).Value( ), _
                           DecimalParse( "11000" ).Value( ), _
                           DecimalParse( "250" ).Value( ) ).Value( ).ToString( )   '' 0.125

'' No change is exactly zero; a halving is exactly -0.5.
print HoldingPeriodReturn( DecimalFromInt( 100 ), DecimalFromInt( 100 ), _
                           DecimalZero( ) ).Value( ).IsZero( )                     '' true
print HoldingPeriodReturn( DecimalFromInt( 100 ), DecimalFromInt( 50 ), _
                           DecimalZero( ) ).Value( ).ToString( )                   '' -0.5

'' A zero opening value is a named refusal, not an infinity.
print HoldingPeriodReturn( DecimalZero( ), DecimalFromInt( 100 ), _
                           DecimalZero( ) ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finport.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
