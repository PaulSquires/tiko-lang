[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Microseconds**

# TimeSpan.Microseconds

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TimeSpan.Microseconds
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as TimeSpan t = TimeSpan.FromMicroseconds( 1234567 )

print t.Microseconds         '' 234567 -- within the SECOND, so it
                             '' includes the milliseconds
print t.Milliseconds         '' 234
print t.TotalMicroseconds    '' 1234567
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
