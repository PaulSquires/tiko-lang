[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.DayOfYear**

# LocalDate.DayOfYear

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LocalDate.DayOfYear
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print LocalDate( 2026, 1, 1 ).DayOfYear     '' 1 -- one-based
print LocalDate( 2026, 8, 13 ).DayOfYear    '' 225
print LocalDate( 2026, 12, 31 ).DayOfYear   '' 365

'' 366 in a leap year
print LocalDate( 2024, 12, 31 ).DayOfYear   '' 366
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
