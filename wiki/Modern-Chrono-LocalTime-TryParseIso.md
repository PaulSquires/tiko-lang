[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.TryParseIso**

# LocalTime.TryParseIso

## Syntax

```freebasic
LocalTime.TryParseIso
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as LocalTime t

if LocalTime.TryParseIso( "14:30:05", t ) then print t.ToIsoString( )

'' FALSE on a bad string -- and the output is CLOBBERED, not preserved:
'' it is set to Invalid before the parse is attempted
print LocalTime.TryParseIso( "25:00:00", t )      '' false
print t.IsValid                                   '' false

'' ParseIso is the same parse, returning Invalid instead of answering
'' with a boolean
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
