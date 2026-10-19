[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **PresentValueOfLump**

# PresentValueOfLump

Returns a single future amount discounted back a number of periods.

## Syntax

```freebasic
PresentValueOfLump( amount, ratePerPeriod, periods )
```

## Examples

```freebasic
#import "std/money"
using money

'' A single amount discounted back.  A MULTIPLY, not a rearrangement of
'' the annuity identity -- so the SIGN IS UNCHANGED, unlike PresentValue.
dim as Decimal i = DecimalParse( "0.10" ).Value( )

print PresentValueOfLump( DecimalParse( "1000" ).Value( ), i, 0 ).Value( ).ToString( )   '' 1000
print PresentValueOfLump( DecimalParse( "1000" ).Value( ), i, 10 ).Value( ).ToStringFixed( 2 )  '' 385.54

'' Positive in, positive out.
dim as Decimal pv = PresentValueOfLump( DecimalParse( "1000" ).Value( ), i, 5 ).Value( )
print ( pv > DecimalZero( ) )            '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fintvm.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
