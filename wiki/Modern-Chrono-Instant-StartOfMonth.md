[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.StartOfMonth**

# DateTime.StartOfMonth

Returns midnight on the first day of the month.

## Syntax

```freebasic
DateTime.StartOfMonth
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.StartOfMonth( ).ToIsoString( )   '' 2026-08-01T00:00:00

'' The time of day is zeroed too, not just the day
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
