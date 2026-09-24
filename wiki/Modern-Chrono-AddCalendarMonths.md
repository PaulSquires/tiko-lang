[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **AddCalendarMonths**

# AddCalendarMonths

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

calendar months, offset re-resolved.

## Syntax

```freebasic
AddCalendarMonths( 1 )
```

## Notes

- calendar months, offset re-resolved.

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' "Same time next month": AddMonths, then the offset re-resolved for
'' the new local time
dim as DateTime d = DateTime( 2026, 1, 31, 12, 0, 0, 0 )

print d.AddCalendarMonths( 1 ).ToIsoString( )     '' 2026-02-28T12:00:00

'' The day still CLAMPS to the end of the shorter month -- that is
'' calendar arithmetic everywhere, not a DST question
print d.AddCalendarMonths( 1 ).Day                '' 28
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** Exact Arithmetic Vs Calendar Arithmetic  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
