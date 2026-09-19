[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.IsValid**

# LocalDate.IsValid

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LocalDate.IsValid
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print LocalDate( 2026, 8, 13 ).IsValid      '' true
print LocalDate( 2025, 2, 30 ).IsValid      '' false -- no such date
print LocalDate( 2024, 2, 29 ).IsValid      '' true -- 2024 is a leap year

'' The only correct test: an Invalid value never compares equal to
'' anything, itself included
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
