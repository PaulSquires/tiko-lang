[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.Hour**

# LocalTime.Hour

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LocalTime.Hour
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as LocalTime t = LocalTime( 14, 30, 5, 0 )
print t.Hour                 '' 14

'' 0 to 23. There is no 12-hour form and no AM/PM here -- that is a
'' formatting concern, not a component one.
print LocalTime.Midnight( ).Hour        '' 0
print LocalTime.Noon( ).Hour            '' 12
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
