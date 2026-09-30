[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **AddCalendarDays**

# AddCalendarDays

offset, so across a DST boundary it is 23 or 25 hours of real time.

## Syntax

```freebasic
AddCalendarDays( 1 )
```

## Notes

- same wall-clock time tomorrow. Re-resolves the

## Examples

```freebasic
#import "std/chrono"
using FB

'' CALENDAR arithmetic: "same time tomorrow". It walks the civil date
'' and then re-resolves the offset, so the wall-clock time survives a
'' DST boundary -- where AddDays( 1 ), being exactly 86400 seconds,
'' would shift it by an hour.
dim as DateTime d = DateTime( 2026, 3, 7, 12, 0, 0, 0 )

print d.AddCalendarDays( 1 ).ToIsoString( )       '' 2026-03-08T12:00:00
print d.AddCalendarDays( -7 ).ToIsoString( )      '' 2026-02-28T12:00:00

'' With no offset attached there is nothing to re-resolve and the two
'' agree exactly
print d.HasOffset            '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** Exact Arithmetic Vs Calendar Arithmetic  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
