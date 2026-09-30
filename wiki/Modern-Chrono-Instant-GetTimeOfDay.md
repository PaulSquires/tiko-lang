[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.GetTimeOfDay**

# Instant.GetTimeOfDay

## Syntax

```freebasic
Instant.GetTimeOfDay
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
dim as LocalTime lt = d.GetTimeOfDay( )

print lt.ToIsoString( )      '' 14:30:05.12300000000

'' DateTime.FromDateTime( d.GetDate( ), d.GetTimeOfDay( ) ) rebuilds the
'' civil value
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
