[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.FromDays**

# TimeSpan.FromDays

## Syntax

```freebasic
TimeSpan.FromDays
```

## Examples

```freebasic
#import "std/chrono"
using chrono

print TimeSpan.FromDays( 1 ).TotalHours          '' 24
print TimeSpan.FromDays( 0.5 ).TotalHours        '' 12 -- fractional
print TimeSpan.FromDays( -1 ).IsNegative         '' true

'' A day here is always exactly 24 hours. Across a DST boundary a
'' CALENDAR day may not be, which is what AddCalendarDays is for.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
