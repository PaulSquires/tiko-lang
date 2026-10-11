[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DayCountDays**

# DayCountDays

## Syntax

```freebasic
DayCountDays( d1, d2, basis )
```

## Examples

```freebasic
#import "std/chrono"
#import "std/money"
using money, chrono

'' The day count between two dates on a basis.  The actual bases count
'' real days; the 30/360 pair apply their end-of-month rules first.
dim as LocalDate a = LocalDate( 2026, 1, 31 )
dim as LocalDate b = LocalDate( 2026, 3, 31 )

print DayCountDays( a, b, DAYCOUNT_ACTUAL_365_FIXED )   '' 59
print DayCountDays( a, b, DAYCOUNT_THIRTY_360_US )      '' 60

'' A leap year really is 366 days.
print DayCountDays( LocalDate( 2024, 1, 1 ), LocalDate( 2025, 1, 1 ), _
                    DAYCOUNT_ACTUAL_360 )               '' 366
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincore.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
