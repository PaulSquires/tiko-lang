[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.FromDayNumber**

# LocalDate.FromDayNumber

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LocalDate.FromDayNumber( days )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' Days since 0001-01-01, which is day 0
dim as LocalDate epoch = LocalDate.FromDayNumber( 0 )
print epoch.ToIsoString( )               '' 0001-01-01

dim as LocalDate d = LocalDate( 2026, 8, 13 )
print LocalDate.FromDayNumber( d.DayNumber ).ToIsoString( )     '' 2026-08-13

'' The inverse of the DayNumber property, so the pair round-trips
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
