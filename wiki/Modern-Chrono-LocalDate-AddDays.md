[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.AddDays**

# LocalDate.AddDays

## Syntax

```freebasic
LocalDate.AddDays( n )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalDate d = LocalDate( 2026, 8, 13 )

print d.AddDays( 10 ).ToIsoString( )     '' 2026-08-23
print d.AddDays( -13 ).ToIsoString( )    '' 2026-07-31 -- crosses the month

'' IMMUTABLE: this returns a NEW value and does not modify the receiver
d.AddDays( 100 )
print d.ToIsoString( )                   '' 2026-08-13, unchanged
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
