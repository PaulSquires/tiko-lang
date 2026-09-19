[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.WeeksInYear**

# Instant.WeeksInYear

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Instant.WeeksInYear( y )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' 52 or 53, depending on which weekdays the year starts and ends on
print DateTime.WeeksInYear( 2026 )      '' 53
print DateTime.WeeksInYear( 2025 )      '' 52

'' A static: it is a property of the YEAR, not of a particular moment
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
