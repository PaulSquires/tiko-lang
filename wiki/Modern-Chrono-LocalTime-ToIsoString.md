[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.ToIsoString**

# LocalTime.ToIsoString

## Syntax

```freebasic
LocalTime.ToIsoString
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print LocalTime( 14, 30, 5, 0 ).ToIsoString( )         '' 14:30:05
print LocalTime( 14, 30, 5, 123 ).ToIsoString( )    '' 14:30:05.123
print LocalTime.Midnight( ).ToIsoString( )          '' 00:00:00

'' ISO 8601, so it round-trips through ParseIso. The fraction appears
'' only when it is non-zero.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
