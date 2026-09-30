[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.Microsecond**

# Instant.Microsecond

## Syntax

```freebasic
Instant.Microsecond
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.Microsecond          '' 123000

'' Within the SECOND, so it INCLUDES the milliseconds -- it is not the
'' 0-999 remainder after them. Take `Microsecond mod 1000` for that.
print d.Microsecond mod 1000     '' 0
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
