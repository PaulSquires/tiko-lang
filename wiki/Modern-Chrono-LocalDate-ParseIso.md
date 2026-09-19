[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.ParseIso**

# LocalDate.ParseIso

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LocalDate.ParseIso(+ USTRING overloads, .ToIsoUString)
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as LocalDate d = LocalDate.ParseIso( "2026-08-13" )
print d.Year & " " & d.Month & " " & d.Day        '' 2026 8 13

'' A bad string yields Invalid, with no exception and no ERR( )
print LocalDate.ParseIso( "2026-02-30" ).IsValid   '' false
print LocalDate.ParseIso( "13/08/2026" ).IsValid   '' false -- ISO only
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
