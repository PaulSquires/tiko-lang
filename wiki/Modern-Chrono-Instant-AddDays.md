[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.AddDays**

# Instant.AddDays

Returns the date-time moved by days of exactly 24 hours, fractions allowed.

## Syntax

```freebasic
Instant.AddDays
```

## Examples

```freebasic
#import "std/chrono"
using chrono

'' EXACT arithmetic -- 86400 seconds per day, and the argument is a
'' DOUBLE, so fractions are allowed
dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )

print d.AddDays( 1 ).Day             '' 14
print d.AddDays( 0.5 ).Hour          '' 2 -- half a day later, next morning
print d.AddDays( -13 ).ToIsoString( )            '' 2026-07-31T14:30:05.1230000

'' "Same time tomorrow" across a DST boundary is AddCalendarDays
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
