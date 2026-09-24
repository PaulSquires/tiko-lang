[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.IsLeapYear**

# Instant.IsLeapYear

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Instant.IsLeapYear( y )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print DateTime.IsLeapYear( 2024 )       '' true
print DateTime.IsLeapYear( 2025 )       '' false

'' The full Gregorian rule, not just "divisible by 4"
print DateTime.IsLeapYear( 1900 )       '' false -- century, not by 400
print DateTime.IsLeapYear( 2000 )       '' true  -- divisible by 400
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
