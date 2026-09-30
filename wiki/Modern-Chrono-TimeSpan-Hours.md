[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Hours**

# TimeSpan.Hours

## Syntax

```freebasic
TimeSpan.Hours
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim as TimeSpan t = TimeSpan( 1, 2, 3, 4, 0 )

print t.Hours                '' 2 -- 0 to 23, the piece within the day
print t.TotalHours           '' 26.05...

'' -1h30m has Hours = -1 AND Minutes = -30, not -1 and +30, so the
'' pieces always reconstruct the whole
dim as TimeSpan n = TimeSpan.FromMinutes( -90 )
print n.Hours & " " & n.Minutes             '' -1 -30
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
