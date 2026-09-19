[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.IsLastDayOfMonth**

# LocalDate.IsLastDayOfMonth

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LocalDate.IsLastDayOfMonth
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print LocalDate( 2026, 8, 31 ).IsLastDayOfMonth      '' true
print LocalDate( 2026, 8, 30 ).IsLastDayOfMonth      '' false

'' The one that needs the calendar: February's last day is the 28th or
'' the 29th depending on the year
print LocalDate( 2024, 2, 29 ).IsLastDayOfMonth      '' true
print LocalDate( 2025, 2, 28 ).IsLastDayOfMonth      '' true
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
