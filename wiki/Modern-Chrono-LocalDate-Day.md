[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.Day**

# LocalDate.Day

Returns the day of the month, starting at 1.

## Syntax

```freebasic
LocalDate.Day
```

## Examples

```freebasic
#import "std/chrono"
using chrono

print LocalDate( 2026, 8, 13 ).Day        '' 13

'' 1 to the length of that month, one-based
print LocalDate( 2026, 8, 1 ).Day         '' 1
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
