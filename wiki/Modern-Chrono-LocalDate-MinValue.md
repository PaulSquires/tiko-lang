[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.MinValue**

# LocalDate.MinValue

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LocalDate.MinValue
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as LocalDate d = LocalDate.MinValue( )

print d.ToIsoString( )       '' 0001-01-01
print d.DayNumber            '' 0

'' Subtracting a day from it overflows, and overflow yields Invalid
'' rather than wrapping
print d.AddDays( -1 ).IsValid           '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
