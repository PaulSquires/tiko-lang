[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.ToIsoString**

# LocalDate.ToIsoString

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LocalDate.ToIsoString
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print LocalDate( 2026, 8, 13 ).ToIsoString( )      '' 2026-08-13

'' Always zero-padded to YYYY-MM-DD, so it sorts as text in the same
'' order it sorts as a date
print LocalDate( 1, 1, 1 ).ToIsoString( )          '' 0001-01-01
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
