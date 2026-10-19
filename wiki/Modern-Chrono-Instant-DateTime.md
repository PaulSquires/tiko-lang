[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.DateTime**

# Instant.DateTime

Creates a date-time from a year, month, day and optional time, or Invalid if none.

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
#import "std/chrono"
using chrono

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

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
