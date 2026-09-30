[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.NextWeekday**

# Instant.NextWeekday

## Syntax

```freebasic
Instant.NextWeekday( dow )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' The next Monday STRICTLY AFTER this value -- never the value itself,
'' even when it already falls on that weekday
print d.DayOfWeek                        '' 4, a Thursday
print d.NextWeekday( DT_MONDAY ).ToIsoString( )     '' 2026-08-17T14:30:05.1230000

'' The time of day is preserved, so this is "same time, next Monday"
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
