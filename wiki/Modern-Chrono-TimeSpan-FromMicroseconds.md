[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.FromMicroseconds**

# TimeSpan.FromMicroseconds

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

longint, not double

## Syntax

```freebasic
TimeSpan.FromMicroseconds( longint )
```

## Notes

- longint, not double

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print TimeSpan.FromMicroseconds( 1000000 ).TotalSeconds      '' 1

'' Takes a LONGINT, not a double like the other From* functions: at
'' microsecond resolution a double would start losing whole ticks
print TimeSpan.FromMicroseconds( 1 ).Ticks       '' 10 -- ten 100 ns ticks
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
