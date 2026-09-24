[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FutureValueOfLump**

# FutureValueOfLump

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
FutureValueOfLump( amount, ratePerPeriod, periods )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' A single amount compounded forward.  Also a plain multiply.
dim as Decimal i = DecimalParse( "0.10" ).Value( )

'' 1.1^10 terminates, so this is EXACT to the last digit.
print FutureValueOfLump( DecimalParse( "1000" ).Value( ), i, 10 ).Value( ).ToStringFixed( 7 )   '' 2593.7424601

'' Round trip with PresentValueOfLump returns the original.
dim as Decimal fv = FutureValueOfLump( DecimalParse( "1000" ).Value( ), i, 10 ).Value( )
print PresentValueOfLump( fv, i, 10 ).Value( ).ToStringFixed( 2 )         '' 1000.00
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fintvm.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
