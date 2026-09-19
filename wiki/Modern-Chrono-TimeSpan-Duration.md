[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Duration**

# TimeSpan.Duration

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TimeSpan.Duration
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as TimeSpan t = TimeSpan.FromHours( -2 )

'' The absolute value: how long, regardless of direction
print t.Duration( ).IsNegative           '' false
print t.Duration( ).TotalHours           '' 2

'' Already positive, so it is a no-op there
print TimeSpan.FromHours( 2 ).Duration( ).TotalHours    '' 2
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
