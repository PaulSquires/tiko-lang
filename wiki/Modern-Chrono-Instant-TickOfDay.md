[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.TickOfDay**

# Instant.TickOfDay

## Syntax

```freebasic
Instant.TickOfDay
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' Ticks since midnight, which is the time of day as one number
print d.TickOfDay            '' 522051230000

print d.TickOfDay / DT_TICKS_PER_HOUR >= 14      '' -1 (true)

'' StartOfDay is the same value with this set to zero
print d.StartOfDay( ).TickOfDay      '' 0
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
