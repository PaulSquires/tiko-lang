[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **IsHighResolution**

# IsHighResolution

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Whether the platform counter is a high-resolution one.

## Syntax

```freebasic
Stopwatch.IsHighResolution( ) as boolean
```

## Notes

- TRUE on every current desktop platform; it is FALSE only where the OS has no better clock than the system tick.
- When it is FALSE, a measurement below roughly 15 ms is noise rather than a number.
- A static, and constant for the life of the process.

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print Stopwatch.IsHighResolution( )           '' true on a modern machine

'' When this is FALSE, anything under ~15 ms is noise rather than a
'' measurement
if Stopwatch.IsHighResolution( ) = false then print "coarse clock"
print "checked"
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
