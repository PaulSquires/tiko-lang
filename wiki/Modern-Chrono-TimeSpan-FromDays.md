[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.FromDays**

# TimeSpan.FromDays

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TimeSpan.FromDays
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print TimeSpan.FromDays( 1 ).TotalHours          '' 24
print TimeSpan.FromDays( 0.5 ).TotalHours        '' 12 -- fractional
print TimeSpan.FromDays( -1 ).IsNegative         '' true

'' A day here is always exactly 24 hours. Across a DST boundary a
'' CALENDAR day may not be, which is what AddCalendarDays is for.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
