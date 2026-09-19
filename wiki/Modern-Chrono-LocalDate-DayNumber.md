[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.DayNumber**

# LocalDate.DayNumber

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LocalDate.DayNumber
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as LocalDate d = LocalDate( 2026, 8, 13 )

print d.DayNumber            '' 739840

'' The whole value is this one number. Subtracting two of them is the
'' number of days between the dates, which needs no arithmetic on the
'' type itself.
dim as LocalDate e = d.AddDays( 10 )
print e.DayNumber - d.DayNumber         '' 10
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
