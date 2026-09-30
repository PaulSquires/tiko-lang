[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DayCountFraction**

# DayCountFraction

## Syntax

```freebasic
DayCountFraction( d1, d2, basis )
```

## Examples

```freebasic
#import "std/money"
using FB

'' The year fraction, EXACT -- an integer over an integer.
dim as LocalDate a = LocalDate( 2026, 1, 1 )
dim as LocalDate b = LocalDate( 2027, 1, 1 )

'' A common year on Act/365F is exactly one.
print ( DayCountFraction( a, b, DAYCOUNT_ACTUAL_365_FIXED ) = DecimalOne( ) )  '' true

'' The same span on Act/360 is MORE than a year, which is the point of
'' the basis rather than a defect.
print ( DayCountFraction( a, b, DAYCOUNT_ACTUAL_360 ) > DecimalOne( ) )       '' true

'' Act/Act splits at each 1 January, so four years spanning one leap
'' year come to exactly 4.
print DayCountFraction( LocalDate( 2023, 1, 1 ), LocalDate( 2027, 1, 1 ), _
                        DAYCOUNT_ACTUAL_ACTUAL_ISDA ).ToString( )              '' 4
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
