[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.AddMonths**

# Instant.AddMonths

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Instant.AddMonths( n )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as DateTime d = DateTime( 2026, 1, 31, 12, 0, 0, 0 )

'' The day CLAMPS to the end of the target month, never rolls over
print d.AddMonths( 1 ).ToIsoString( )    '' 2026-02-28T12:00:00

'' So it does not round-trip
print d.AddMonths( 1 ).AddMonths( -1 ).Day       '' 28
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
