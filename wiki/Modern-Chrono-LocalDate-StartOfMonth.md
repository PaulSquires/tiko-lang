[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.StartOfMonth**

# LocalDate.StartOfMonth

Returns the first day of the date's month.

## Syntax

```freebasic
LocalDate.StartOfMonth
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalDate d = LocalDate( 2026, 8, 13 )

print d.StartOfMonth( ).ToIsoString( )   '' 2026-08-01

'' Already the first day, so it is a no-op there
print LocalDate( 2026, 8, 1 ).StartOfMonth( ).ToIsoString( )    '' 2026-08-01
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
