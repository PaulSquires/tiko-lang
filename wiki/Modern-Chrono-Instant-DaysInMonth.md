[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.DaysInMonth**

# Instant.DaysInMonth

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Instant.DaysInMonth( y, mo )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print DateTime.DaysInMonth( 2026, 8 )   '' 31
print DateTime.DaysInMonth( 2026, 2 )   '' 28
print DateTime.DaysInMonth( 2024, 2 )   '' 29 -- leap year

'' Static, taking the year and month rather than a DateTime
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
