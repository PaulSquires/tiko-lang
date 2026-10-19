[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.DayOfWeek**

# Instant.DayOfWeek

Returns the day of the week, 1 for Monday to 7 for Sunday.

## Syntax

```freebasic
Instant.DayOfWeek
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' ISO NUMBERING: Monday 1 through Sunday 7
print d.DayOfWeek            '' 4 -- a Thursday
print DateTime.WeekdayName( d.DayOfWeek )        '' Thursday
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
