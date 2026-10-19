[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **AddDays**

# AddDays

Adds days of exactly 24 hours, so the clock time can shift across a DST change.

## Syntax

```freebasic
AddDays( 1 )
```

## Notes

- exactly 86400 seconds. Does NOT keep the wall-clock

## Examples

```freebasic
#import "std/chrono"
using chrono

'' EXACT arithmetic: 86400 seconds, which does NOT keep the wall-clock
'' time across a DST boundary. "24 hours from now".
dim as DateTime d = DateTime( 2026, 3, 7, 12, 0, 0, 0 )

print d.AddDays( 1 ).ToIsoString( )      '' 2026-03-08T12:00:00

'' The pair to compare it against is AddCalendarDays, which operates on
'' the civil fields instead. On a zoned value they differ twice a year,
'' and the names say which is which.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** Exact Arithmetic Vs Calendar Arithmetic
