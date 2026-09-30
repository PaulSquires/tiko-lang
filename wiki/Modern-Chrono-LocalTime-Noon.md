[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.Noon**

# LocalTime.Noon

## Syntax

```freebasic
LocalTime.Noon
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as LocalTime t = LocalTime.Noon( )

print t.Hour                 '' 12
print t.ToIsoString( )       '' 12:00:00
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
