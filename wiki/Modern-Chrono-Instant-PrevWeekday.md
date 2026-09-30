[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.PrevWeekday**

# Instant.PrevWeekday

## Syntax

```freebasic
Instant.PrevWeekday( dow )
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' The previous Monday, strictly before this value
print d.PrevWeekday( DT_MONDAY ).ToIsoString( )     '' 2026-08-10T14:30:05.1230000

'' Strictly before, so a value already on a Monday goes back a full week
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
