[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.IsoWeek**

# Instant.IsoWeek

## Syntax

```freebasic
Instant.IsoWeek
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' ISO 8601 week number. A week belongs to the year holding its
'' THURSDAY, so this and IsoWeekYear come as a pair.
print d.IsoWeek              '' 33
print d.IsoWeekYear          '' 2026
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
