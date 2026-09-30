[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.IsFirstDayOfMonth**

# LocalDate.IsFirstDayOfMonth

## Syntax

```freebasic
LocalDate.IsFirstDayOfMonth
```

## Examples

```freebasic
#import "std/chrono"
using FB

print LocalDate( 2026, 8, 1 ).IsFirstDayOfMonth      '' true
print LocalDate( 2026, 8, 13 ).IsFirstDayOfMonth     '' false

'' Reads better than `d.Day = 1` at a call site, and pairs with
'' IsLastDayOfMonth, which cannot be written as simply
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
