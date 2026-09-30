[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.IsLastDayOfMonth**

# Instant.IsLastDayOfMonth

## Syntax

```freebasic
Instant.IsLastDayOfMonth
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.IsLastDayOfMonth     '' false
print d.EndOfMonth( ).IsLastDayOfMonth           '' true

'' The one that needs the calendar -- February is the 28th or the 29th
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
