[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.EndOfMonth**

# LocalDate.EndOfMonth

## Syntax

```freebasic
LocalDate.EndOfMonth
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print LocalDate( 2026, 8, 13 ).EndOfMonth( ).ToIsoString( )     '' 2026-08-31

'' February needs the calendar, which is the point of having this
print LocalDate( 2024, 2, 1 ).EndOfMonth( ).ToIsoString( )      '' 2024-02-29
print LocalDate( 2025, 2, 1 ).EndOfMonth( ).ToIsoString( )      '' 2025-02-28
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
