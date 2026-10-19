[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Days**

# TimeSpan.Days

Returns the days part of the duration, negative for a negative span.

## Syntax

```freebasic
TimeSpan.Days
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan t = TimeSpan( 1, 2, 3, 4, 0 )

print t.Days                 '' 1 -- the component
print t.TotalDays            '' 1.0855... -- the whole span

'' Components of a NEGATIVE span are ALL negative, matching C#
print TimeSpan( -1, -2, 0, 0, 0 ).Days      '' -1
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
