[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.FromDate**

# Instant.FromDate

## Syntax

```freebasic
Instant.FromDate( date )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as LocalDate ld = LocalDate( 2026, 8, 13 )
dim as DateTime d = DateTime.FromDate( ld )

print d.ToIsoString( )       '' 2026-08-13T00:00:00 -- midnight
print d.Hour                 '' 0
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
