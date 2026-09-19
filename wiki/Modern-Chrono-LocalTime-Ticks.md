[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.Ticks**

# LocalTime.Ticks

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LocalTime.Ticks
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as LocalTime t = LocalTime( 1, 0, 0, 0 )

print t.Ticks                '' 36000000000 -- one hour in 100 ns ticks

'' The whole value is this one number, which is why a LocalTime passes
'' in a register and copies trivially
print t.Ticks / DT_TICKS_PER_HOUR       '' 1
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
