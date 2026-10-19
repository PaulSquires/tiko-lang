[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Seconds**

# TimeSpan.Seconds

Returns the seconds part, 0 to 59, negative for a negative span.

## Syntax

```freebasic
TimeSpan.Seconds
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan t = TimeSpan( 2, 3, 4 )

print t.Seconds              '' 4 -- 0 to 59, within the minute
print t.TotalSeconds         '' 7384
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
