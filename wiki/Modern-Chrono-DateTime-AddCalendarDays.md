[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.AddCalendarDays**

# DateTime.AddCalendarDays

Returns the same clock time a number of days later, even across a DST change.

## Syntax

```freebasic
DateTime.AddCalendarDays( n )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' "Same time tomorrow": walks the civil date and re-resolves the
'' offset, so the wall-clock time survives a DST boundary where
'' AddDays( 1 ) -- exactly 86400 seconds -- would shift it
print d.AddCalendarDays( 1 ).ToIsoString( )      '' 2026-08-14T14:30:05.1230000

'' With no offset attached there is nothing to re-resolve, so the two
'' agree exactly
print d.HasOffset            '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
