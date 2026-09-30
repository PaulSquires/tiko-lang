[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.StartOfWeek**

# Instant.StartOfWeek

## Syntax

```freebasic
Instant.StartOfWeek( firstDay = DT_MONDAY )
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' Defaults to MONDAY, the ISO convention
print d.StartOfWeek( ).ToIsoString( )               '' 2026-08-10T00:00:00
print d.StartOfWeek( ).DayOfWeek                    '' 1

'' Or name the day the week starts on
print d.StartOfWeek( DT_SUNDAY ).ToIsoString( )     '' 2026-08-09T00:00:00
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
