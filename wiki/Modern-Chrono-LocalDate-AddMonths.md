[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.AddMonths**

# LocalDate.AddMonths

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LocalDate.AddMonths( n )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as LocalDate d = LocalDate( 2026, 1, 31 )

'' The day is CLAMPED to the end of the target month, never rolled over
'' into the next one
print d.AddMonths( 1 ).ToIsoString( )    '' 2026-02-28

'' Which means it does not round-trip: adding a month and subtracting it
'' does not always return the original day
print d.AddMonths( 1 ).AddMonths( -1 ).ToIsoString( )      '' 2026-01-28
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
