[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.TotalMicroseconds**

# TimeSpan.TotalMicroseconds

Returns the whole duration in whole microseconds.

## Syntax

```freebasic
TimeSpan.TotalMicroseconds
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan t = TimeSpan.FromSeconds( 1 )

print t.TotalMicroseconds    '' 1000000

'' A LONGINT rather than a double -- at this resolution a double would
'' start losing whole ticks, and this is the last unit above the tick
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
