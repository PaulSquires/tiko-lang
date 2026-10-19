[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.StartOfDay**

# Instant.StartOfDay

Returns midnight at the start of the same day, keeping the offset.

## Syntax

```freebasic
Instant.StartOfDay
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.StartOfDay( ).ToIsoString( )     '' 2026-08-13T00:00:00
print d.StartOfDay( ).TickOfDay          '' 0
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
