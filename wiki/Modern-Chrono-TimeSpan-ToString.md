[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.ToString**

# TimeSpan.ToString

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TimeSpan.ToString
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print TimeSpan( 1, 2, 3, 4, 5 ).ToString( )        '' P1DT2H3M4.005S
print TimeSpan( 2, 3, 4 ).ToString( )              '' PT2H3M4S
print TimeSpan.FromHours( -2 ).ToString( )         '' -PT2H

'' IDENTICAL TO ToIsoString -- ToString calls it. There is no separate
'' d.hh:mm:ss layout for this type, so anything printing a TimeSpan gets
'' the ISO duration form and it round-trips through ParseIso.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
