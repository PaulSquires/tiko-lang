[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.GetDate**

# Instant.GetDate

## Syntax

```freebasic
Instant.GetDate
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
dim as LocalDate ld = d.GetDate( )

print ld.ToIsoString( )      '' 2026-08-13
print ld.DayOfWeek           '' 4

'' The time of day and the offset are dropped -- pair it with
'' GetTimeOfDay to take the whole value apart
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
