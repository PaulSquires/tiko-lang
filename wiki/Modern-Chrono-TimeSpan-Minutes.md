[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Minutes**

# TimeSpan.Minutes

## Syntax

```freebasic
TimeSpan.Minutes
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan t = TimeSpan( 2, 3, 4 )

print t.Minutes              '' 3 -- 0 to 59, within the hour
print t.TotalMinutes         '' 123.0666...
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
