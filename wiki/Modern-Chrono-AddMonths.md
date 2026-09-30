[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **AddMonths**

# AddMonths

calendar months, offset untouched.

## Syntax

```freebasic
AddMonths( 1 )
```

## Notes

- calendar months, offset untouched.

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' Exact-field arithmetic on the calendar: the offset is left untouched
dim as DateTime d = DateTime( 2026, 1, 31, 12, 0, 0, 0 )

print d.AddMonths( 1 ).ToIsoString( )    '' 2026-02-28T12:00:00 -- clamped

'' AddCalendarMonths is the same walk with the zone offset re-resolved
'' afterwards, which is what "same time next month" means where DST
'' changes in between
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** Exact Arithmetic Vs Calendar Arithmetic  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
