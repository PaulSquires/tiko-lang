[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.JulianDayNumber**

# Instant.JulianDayNumber

## Syntax

```freebasic
Instant.JulianDayNumber
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' The whole-number day, for calendars and astronomy that count days
'' rather than instants
print DateTime( 2000, 1, 1, 12, 0, 0, 0 ).WithOffset( 0 ).JulianDayNumber    '' 2451545

'' The integer partner to JulianDay, without the noon-based fraction
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
