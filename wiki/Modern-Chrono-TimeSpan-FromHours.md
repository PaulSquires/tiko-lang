[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.FromHours**

# TimeSpan.FromHours

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

A TimeSpan of `v` hours, which may be fractional.

## Syntax

```freebasic
TimeSpan.FromHours( v )
```

## Notes

- Takes a `double`, so a fractional hour is exact to the tick.
- Rounds **half away from zero** below the tick, matching the rest of the From* family.
- NaN, an infinity, or a value beyond the representable span yields Invalid rather than wrapping or saturating.
- An hour here is always exactly 60 minutes. Across a DST boundary a *calendar* hour may not be, which is `AddCalendarDays`' concern, not this one.

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print TimeSpan.FromHours( 2 ).TotalMinutes       '' 120
print TimeSpan.FromHours( 1.5 ).ToIsoString( )   '' PT1H30M
print TimeSpan.FromHours( -2 ).IsNegative        '' true

'' The components of the result are the broken-down pieces
dim as TimeSpan t = TimeSpan.FromHours( 26.05 )
print t.Days & " " & t.Hours & " " & t.Minutes   '' 1 2 3

'' Out of range yields Invalid, never a wrap
print TimeSpan.FromHours( 1e300 ).IsValid        '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
