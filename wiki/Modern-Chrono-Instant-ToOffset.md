[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.ToOffset**

# Instant.ToOffset

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

convert

## Syntax

```freebasic
Instant.ToOffset( offMin )
```

## Notes

- convert

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
dim as DateTime utc = d.WithOffset( 0 )

'' CONVERTS to another offset, keeping the MOMENT and changing the
'' fields -- the opposite of WithOffset
dim as DateTime plus1 = utc.ToOffset( 60 )

print plus1.Hour             '' 15 -- one hour later on the clock
print plus1.ToInstant( ).Ticks = utc.ToInstant( ).Ticks      '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
