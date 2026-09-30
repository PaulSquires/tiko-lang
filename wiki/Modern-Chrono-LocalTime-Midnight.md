[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.Midnight**

# LocalTime.Midnight

## Syntax

```freebasic
LocalTime.Midnight
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as LocalTime t = LocalTime.Midnight( )

print t.Ticks                '' 0
print t.ToIsoString( )       '' 00:00:00

'' The start of the day, and the smallest valid LocalTime
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
