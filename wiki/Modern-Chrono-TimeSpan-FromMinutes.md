[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.FromMinutes**

# TimeSpan.FromMinutes

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

A TimeSpan of `v` minutes, which may be fractional.

## Syntax

```freebasic
TimeSpan.FromMinutes( v )
```

## Notes

- Takes a `double`, so half a minute is exact.
- Rounds **half away from zero** below the tick.
- NaN or an out-of-range value yields Invalid.
- A minute is always 60 seconds: this library has no leap seconds.

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print TimeSpan.FromMinutes( 90 ).TotalHours      '' 1.5
print TimeSpan.FromMinutes( 0.5 ).TotalSeconds    '' 30
print TimeSpan.FromMinutes( -90 ).ToIsoString( )  '' -PT1H30M

'' Components of a NEGATIVE span are ALL negative, so the pieces still
'' reconstruct the whole
dim as TimeSpan n = TimeSpan.FromMinutes( -90 )
print n.Hours & " " & n.Minutes                   '' -1 -30
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
