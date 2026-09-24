[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.IsoWeek**

# LocalDate.IsoWeek

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LocalDate.IsoWeek
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' The ISO 8601 week number, 1 to 53. A week belongs to the year that
'' holds its THURSDAY, which is why this and IsoWeekYear come as a pair.
print LocalDate( 2026, 8, 13 ).IsoWeek      '' 33

'' The first days of January can fall in the last week of the previous
'' ISO year
dim as LocalDate jan1 = LocalDate( 2027, 1, 1 )
print jan1.IsoWeek & " of " & jan1.IsoWeekYear      '' 53 of 2026
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
