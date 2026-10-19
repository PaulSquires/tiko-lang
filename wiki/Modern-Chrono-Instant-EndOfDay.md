[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.EndOfDay**

# DateTime.EndOfDay

Returns the last tick of the same day, 23:59:59.9999999.

## Syntax

```freebasic
DateTime.EndOfDay
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.EndOfDay( ).ToIsoString( )       '' 2026-08-13T23:59:59.9999999

'' The LAST TICK of the day, not midnight of the next one -- so a
'' `>= StartOfDay and <= EndOfDay` range test cannot include the
'' following day by accident
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
