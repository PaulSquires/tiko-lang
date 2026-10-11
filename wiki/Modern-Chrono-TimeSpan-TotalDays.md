[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.TotalDays**

# TimeSpan.TotalDays

## Syntax

```freebasic
TimeSpan.TotalDays
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan t = TimeSpan( 1, 2, 3, 4, 0 )      '' 1d 2h 3m 4s

'' TOTALS are the WHOLE span in that unit, fractionally
print t.TotalDays            '' 1.0855...

'' The component property is the broken-down piece instead
print t.Days                 '' 1
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
