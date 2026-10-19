[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.DaysInMonth**

# Instant.DaysInMonth

Returns the number of days in a month of a given year.

## Syntax

```freebasic
Instant.DaysInMonth( y, mo )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

print DateTime.DaysInMonth( 2026, 8 )   '' 31
print DateTime.DaysInMonth( 2026, 2 )   '' 28
print DateTime.DaysInMonth( 2024, 2 )   '' 29 -- leap year

'' Static, taking the year and month rather than a DateTime
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
