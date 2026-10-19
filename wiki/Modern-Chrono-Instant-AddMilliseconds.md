[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.AddMilliseconds**

# DateTime.AddMilliseconds

Returns the date-time moved by a number of milliseconds, fractions allowed.

## Syntax

```freebasic
DateTime.AddMilliseconds(float64)
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.AddMilliseconds( 877 ).Second     '' 6
print d.AddMilliseconds( -123 ).Millisecond       '' 0
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
