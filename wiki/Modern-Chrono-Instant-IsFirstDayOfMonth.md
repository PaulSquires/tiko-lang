[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.IsFirstDayOfMonth**

# DateTime.IsFirstDayOfMonth

Returns true if the date is the first day of its month.

## Syntax

```freebasic
DateTime.IsFirstDayOfMonth
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.IsFirstDayOfMonth    '' false
print d.StartOfMonth( ).IsFirstDayOfMonth        '' true
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
