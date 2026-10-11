[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.OffsetMinutes**

# Instant.OffsetMinutes

## Syntax

```freebasic
Instant.OffsetMinutes
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' WITH NO OFFSET ATTACHED THIS IS 32767, the sentinel, NOT zero -- so
'' never read it without checking HasOffset first, or an unzoned value
'' looks like a zone 546 hours ahead
print d.HasOffset            '' false
print d.OffsetMinutes        '' 32767

dim as DateTime z = d.WithOffset( 330 )      '' +05:30
print z.OffsetMinutes        '' 330
print z.ToIsoString( )       '' 2026-08-13T14:30:05.1230000+05:30

'' MINUTES, not hours, because not every zone is a whole number of hours
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
