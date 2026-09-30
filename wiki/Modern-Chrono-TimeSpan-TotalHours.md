[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.TotalHours**

# TimeSpan.TotalHours

## Syntax

```freebasic
TimeSpan.TotalHours
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as TimeSpan t = TimeSpan( 1, 2, 3, 0, 0 )      '' 1d 2h 3m

print t.TotalHours           '' 26.05 -- the whole span in hours
print t.Hours                '' 2 -- the component

'' That pair is the single most useful thing to know about this type
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
