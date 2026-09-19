[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.FromMilliseconds**

# TimeSpan.FromMilliseconds

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

rounds half away from zero

## Syntax

```freebasic
FromMilliseconds( double )
```

## Notes

- rounds half away from zero

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print TimeSpan.FromMilliseconds( 1500 ).TotalSeconds     '' 1.5

'' ROUNDS HALF AWAY FROM ZERO, not to even and not by truncation. A
'' millisecond is 10000 ticks, so a fractional millisecond still lands
'' exactly on a tick.
print TimeSpan.FromMilliseconds( 0.15 ).Ticks    '' 1500
print TimeSpan.FromMilliseconds( 1.5 ).Ticks     '' 15000

'' NaN or a value beyond the representable span yields Invalid rather
'' than wrapping or saturating
print TimeSpan.FromMilliseconds( 1e300 ).IsValid '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
