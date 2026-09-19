[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.LocalTime**

# LocalTime.LocalTime

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

midnight

## Syntax

```freebasic
LocalTime( )
LocalTime( h, mi, s, ms )
```

## Notes

- midnight

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' A time of day with no date and no zone. One LONGINT of 100 ns ticks.
dim as LocalTime t = LocalTime( 14, 30, 5, 0 )

print t.Hour & ":" & t.Minute & ":" & t.Second      '' 14:30:5
print t.ToIsoString( )                              '' 14:30:05

'' Out-of-range construction yields Invalid rather than raising
dim as LocalTime bad = LocalTime( 25, 0, 0, 0 )
print bad.IsValid            '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
