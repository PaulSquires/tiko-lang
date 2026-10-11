[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FutureValueOfLump**

# FutureValueOfLump

## Syntax

```freebasic
FutureValueOfLump( amount, ratePerPeriod, periods )
```

## Examples

```freebasic
#import "std/money"
using money

'' A single amount compounded forward.  Also a plain multiply.
dim as Decimal i = DecimalParse( "0.10" ).Value( )

'' 1.1^10 terminates, so this is EXACT to the last digit.
print FutureValueOfLump( DecimalParse( "1000" ).Value( ), i, 10 ).Value( ).ToStringFixed( 7 )   '' 2593.7424601

'' Round trip with PresentValueOfLump returns the original.
dim as Decimal fv = FutureValueOfLump( DecimalParse( "1000" ).Value( ), i, 10 ).Value( )
print PresentValueOfLump( fv, i, 10 ).Value( ).ToStringFixed( 2 )         '' 1000.00
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fintvm.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
