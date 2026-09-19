[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.FromTicks**

# LocalTime.FromTicks

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LocalTime.FromTicks
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' Ticks since midnight, 100 ns each
dim as LocalTime t = LocalTime.FromTicks( 36000000000ll )    '' one hour

print t.Hour                 '' 1
print t.Ticks                '' 36000000000

'' A tick count at or past a whole day is out of range
dim as LocalTime bad = LocalTime.FromTicks( 864000000000ll )
print bad.IsValid            '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
