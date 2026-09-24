[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.IsValid**

# LocalTime.IsValid

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LocalTime.IsValid
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print LocalTime( 14, 30, 5, 0 ).IsValid      '' true
print LocalTime( 25, 0, 0, 0 ).IsValid       '' false -- no such hour
print LocalTime( 0, 60, 0, 0 ).IsValid       '' false -- no such minute

'' The ONLY correct test. An Invalid value is absorbing: anything that
'' touches it becomes Invalid, and it never compares equal to anything.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
