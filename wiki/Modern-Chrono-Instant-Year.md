[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.Year**

# Instant.Year

Returns the year, 1 to 9999.

## Syntax

```freebasic
Instant.Year
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.Year                 '' 2026

'' 1 to 9999. There is no year 0: the proleptic Gregorian calendar
'' starts at 0001-01-01.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
