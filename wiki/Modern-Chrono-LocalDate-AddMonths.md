[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.AddMonths**

# LocalDate.AddMonths

## Syntax

```freebasic
LocalDate.AddMonths( n )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalDate d = LocalDate( 2026, 1, 31 )

'' The day is CLAMPED to the end of the target month, never rolled over
'' into the next one
print d.AddMonths( 1 ).ToIsoString( )    '' 2026-02-28

'' Which means it does not round-trip: adding a month and subtracting it
'' does not always return the original day
print d.AddMonths( 1 ).AddMonths( -1 ).ToIsoString( )      '' 2026-01-28
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
