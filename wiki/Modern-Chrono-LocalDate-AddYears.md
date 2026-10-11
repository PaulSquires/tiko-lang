[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.AddYears**

# LocalDate.AddYears

## Syntax

```freebasic
LocalDate.AddYears( n )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalDate d = LocalDate( 2026, 8, 13 )
print d.AddYears( 4 ).ToIsoString( )     '' 2030-08-13

'' 29 February clamps to the 28th in a non-leap year, the same rule
'' AddMonths follows
print LocalDate( 2024, 2, 29 ).AddYears( 1 ).ToIsoString( )     '' 2025-02-28
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
