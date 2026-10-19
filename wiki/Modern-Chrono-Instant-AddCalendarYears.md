[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.AddCalendarYears**

# Instant.AddCalendarYears

Returns the same clock time some years later, with the UTC offset worked out again.

## Syntax

```freebasic
Instant.AddCalendarYears( n )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.AddCalendarYears( 4 ).Year               '' 2030

'' AddCalendarMonths( n * 12 ), so it clamps 29 February the same way
'' and re-resolves the offset afterwards
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
