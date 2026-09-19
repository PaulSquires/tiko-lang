[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **AddDays**

# AddDays

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

time across a DST boundary.

## Syntax

```freebasic
AddDays( 1 )
```

## Notes

- exactly 86400 seconds. Does NOT keep the wall-clock

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' EXACT arithmetic: 86400 seconds, which does NOT keep the wall-clock
'' time across a DST boundary. "24 hours from now".
dim as DateTime d = DateTime( 2026, 3, 7, 12, 0, 0, 0 )

print d.AddDays( 1 ).ToIsoString( )      '' 2026-03-08T12:00:00

'' The pair to compare it against is AddCalendarDays, which operates on
'' the civil fields instead. On a zoned value they differ twice a year,
'' and the names say which is which.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** Exact Arithmetic Vs Calendar Arithmetic  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
