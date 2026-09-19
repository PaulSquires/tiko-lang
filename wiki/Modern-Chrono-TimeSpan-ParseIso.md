[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.ParseIso**

# TimeSpan.ParseIso

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TimeSpan.ParseIso( s )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as TimeSpan t = TimeSpan.ParseIso( "P1DT2H3M4S" )

print t.Days & " " & t.Hours & " " & t.Minutes & " " & t.Seconds    '' 1 2 3 4
print TimeSpan.ParseIso( "PT1.5S" ).TotalSeconds       '' 1.5
print TimeSpan.ParseIso( "-PT2H" ).IsNegative          '' true

'' A bad string yields Invalid -- no exception, no ERR( )
print TimeSpan.ParseIso( "1 hour" ).IsValid            '' false

'' There is no month or year designator: P1M would be a calendar period,
'' which a TimeSpan cannot represent
print TimeSpan.ParseIso( "P1M" ).IsValid               '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
