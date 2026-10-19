[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.IsLastDayOfMonth**

# LocalDate.IsLastDayOfMonth

Returns true if the date is the last day of its month.

## Syntax

```freebasic
LocalDate.IsLastDayOfMonth
```

## Examples

```freebasic
#import "std/chrono"
using chrono

print LocalDate( 2026, 8, 31 ).IsLastDayOfMonth      '' true
print LocalDate( 2026, 8, 30 ).IsLastDayOfMonth      '' false

'' The one that needs the calendar: February's last day is the 28th or
'' the 29th depending on the year
print LocalDate( 2024, 2, 29 ).IsLastDayOfMonth      '' true
print LocalDate( 2025, 2, 28 ).IsLastDayOfMonth      '' true
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
