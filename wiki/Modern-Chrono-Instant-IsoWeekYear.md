[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.IsoWeekYear**

# Instant.IsoWeekYear

## Syntax

```freebasic
Instant.IsoWeekYear
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.IsoWeekYear          '' 2026

'' It differs from Year at the turn of the year, which is the whole
'' reason it exists
dim as DateTime j = DateTime( 2027, 1, 1, 0, 0, 0, 0 )
print j.Year & " but ISO week-year " & j.IsoWeekYear      '' 2027 but 2026
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
