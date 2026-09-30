[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.FromDateTime**

# Instant.FromDateTime

## Syntax

```freebasic
Instant.FromDateTime( date, time )
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim as LocalDate ld = LocalDate( 2026, 8, 13 )
dim as LocalTime lt = LocalTime( 14, 30, 5, 0 )

dim as DateTime d = DateTime.FromDateTime( ld, lt )
print d.ToIsoString( )       '' 2026-08-13T14:30:05

'' The inverse pair is GetDate( ) and GetTimeOfDay( )
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
