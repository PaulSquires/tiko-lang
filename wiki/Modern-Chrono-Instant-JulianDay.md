[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.JulianDay**

# Instant.JulianDay

## Syntax

```freebasic
Instant.JulianDay
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' Fractional and NOON-BASED, which is why the half appears
print int( DateTime( 2000, 1, 1, 12, 0, 0, 0 ).WithOffset( 0 ).JulianDay )   '' 2451545

'' JD 2451545.0 is 2000-01-01T12:00 UTC, the standard epoch J2000.0
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
