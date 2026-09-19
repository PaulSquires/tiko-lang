[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.TotalDays**

# TimeSpan.TotalDays

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TimeSpan.TotalDays
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as TimeSpan t = TimeSpan( 1, 2, 3, 4, 0 )      '' 1d 2h 3m 4s

'' TOTALS are the WHOLE span in that unit, fractionally
print t.TotalDays            '' 1.0855...

'' The component property is the broken-down piece instead
print t.Days                 '' 1
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
