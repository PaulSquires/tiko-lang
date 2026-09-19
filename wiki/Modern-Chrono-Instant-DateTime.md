[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.DateTime**

# Instant.DateTime

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Invalid, offset unspecified

## Syntax

```freebasic
DateTime( )
DateTime( y, mo, d )
DateTime( y, mo, d, h, mi, s, ms )
```

## Notes

- Invalid, offset unspecified

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' A DateTime is the CIVIL view: calendar fields plus an optional
'' offset. An Instant is the moment itself.
dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )

print d.ToIsoString( )       '' 2026-08-13T14:30:05.1230000
print d.Year & " " & d.Month & " " & d.Day        '' 2026 8 13

'' Constructed without an offset, so it is a LOCAL wall-clock reading
'' that does not yet name a moment
print d.HasOffset            '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
