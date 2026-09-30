[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **PresentValueOfLump**

# PresentValueOfLump

## Syntax

```freebasic
PresentValueOfLump( amount, ratePerPeriod, periods )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

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
**Source:** `src/inc/fb/fintvm.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
