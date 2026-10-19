[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.AddCalendarMonths**

# DateTime.AddCalendarMonths

Returns the same clock time some months later, clamping the day to the month's end.

## Syntax

```freebasic
DateTime.AddCalendarMonths( n )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 1, 31, 12, 0, 0, 0 )

'' AddMonths, then the offset re-resolved for the new local time
print d.AddCalendarMonths( 1 ).ToIsoString( )    '' 2026-02-28T12:00:00

'' The day still clamps -- that is calendar arithmetic, not a DST
'' question
print d.AddCalendarMonths( 1 ).Day               '' 28
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
