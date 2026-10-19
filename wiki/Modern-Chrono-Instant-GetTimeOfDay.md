[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.GetTimeOfDay**

# DateTime.GetTimeOfDay

Returns the time-of-day part as a LocalTime.

## Syntax

```freebasic
DateTime.GetTimeOfDay
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
dim as LocalTime lt = d.GetTimeOfDay( )

print lt.ToIsoString( )      '' 14:30:05.1230000

'' DateTime.FromDateTime( d.GetDate( ), d.GetTimeOfDay( ) ) rebuilds the
'' civil value
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
