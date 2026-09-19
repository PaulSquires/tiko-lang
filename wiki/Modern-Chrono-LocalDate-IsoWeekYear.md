[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.IsoWeekYear**

# LocalDate.IsoWeekYear

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LocalDate.IsoWeekYear
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' The year the ISO WEEK belongs to, which is not always the calendar
'' year: a week belongs to the year containing its Thursday.
dim as LocalDate jan1 = LocalDate( 2027, 1, 1 )

print jan1.Year              '' 2027
print jan1.IsoWeekYear       '' 2026 -- that week's Thursday is in 2026

'' Always use it WITH IsoWeek. "Week 53" alone is ambiguous.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
