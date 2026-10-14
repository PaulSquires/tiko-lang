[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.FromDayNumber**

# LocalDate.FromDayNumber

## Syntax

```freebasic
LocalDate.FromDayNumber( days )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

'' Days since 0001-01-01, which is day 0
dim as LocalDate epoch = LocalDate.FromDayNumber( 0 )
print epoch.ToIsoString( )               '' 0001-01-01

dim as LocalDate d = LocalDate( 2026, 8, 13 )
print LocalDate.FromDayNumber( d.DayNumber ).ToIsoString( )     '' 2026-08-13

'' The inverse of the DayNumber property, so the pair round-trips
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
