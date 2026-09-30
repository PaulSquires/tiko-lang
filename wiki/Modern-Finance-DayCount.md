[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DayCount**

# DayCount

## Syntax

```freebasic
DAYCOUNT_ACTUAL_365_FIXED  DAYCOUNT_ACTUAL_360  DAYCOUNT_ACTUAL_ACTUAL_ISDA  DAYCOUNT_THIRTY_360_US  DAYCOUNT_THIRTY_E_360  DAYCOUNT_ACTUAL_365_25
```

## Examples

```freebasic
#import "std/money"
using FB

'' The six bases, and the case that separates the two 30/360 variants.
dim as LocalDate a = LocalDate( 2026, 1, 15 )
dim as LocalDate b = LocalDate( 2026, 3, 31 )

'' 30/360 US leaves a day-31 end alone unless the START was 30 or 31.
print DayCountDays( a, b, DAYCOUNT_THIRTY_360_US )   '' 76

'' 30E/360 turns a 31 into a 30 at BOTH ends, unconditionally.
print DayCountDays( a, b, DAYCOUNT_THIRTY_E_360 )    '' 75

'' Actual counts real days.
print DayCountDays( a, b, DAYCOUNT_ACTUAL_365_FIXED ) '' 75
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
