[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.DayOfYear**

# LocalDate.DayOfYear

## Syntax

```freebasic
LocalDate.DayOfYear
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print LocalDate( 2026, 1, 1 ).DayOfYear     '' 1 -- one-based
print LocalDate( 2026, 8, 13 ).DayOfYear    '' 225
print LocalDate( 2026, 12, 31 ).DayOfYear   '' 365

'' 366 in a leap year
print LocalDate( 2024, 12, 31 ).DayOfYear   '' 366
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
