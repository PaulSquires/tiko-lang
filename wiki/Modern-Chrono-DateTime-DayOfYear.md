[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.DayOfYear**

# DateTime.DayOfYear

Returns the day of the year, starting at 1.

## Syntax

```freebasic
DateTime.DayOfYear
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.DayOfYear            '' 225 -- one-based
print DateTime.DaysInYear( d.Year )              '' 365
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
