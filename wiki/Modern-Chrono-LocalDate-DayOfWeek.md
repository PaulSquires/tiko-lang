[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.DayOfWeek**

# LocalDate.DayOfWeek

## Syntax

```freebasic
LocalDate.DayOfWeek
```

## Examples

```freebasic
#import "std/chrono"
using chrono

'' ISO NUMBERING: Monday is 1 through Sunday is 7. NOT the 0-based
'' Sunday-first convention that WEEKDAY and most C code use.
dim as LocalDate d = LocalDate( 2026, 8, 13 )
print d.DayOfWeek            '' 4 -- a Thursday

print LocalDate( 2026, 8, 16 ).DayOfWeek       '' 7 -- Sunday
print LocalDate( 2026, 8, 17 ).DayOfWeek       '' 1 -- Monday

'' Day 0 of the calendar, 0001-01-01, is a Monday, which is where the
'' numbering comes from. IsoWeek depends on this convention.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
