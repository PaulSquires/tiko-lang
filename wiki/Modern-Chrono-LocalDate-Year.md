[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.Year**

# LocalDate.Year

Returns the year, 1 to 9999.

## Syntax

```freebasic
LocalDate.Year
```

## Examples

```freebasic
#import "std/chrono"
using chrono

print LocalDate( 2026, 8, 13 ).Year       '' 2026

'' 1 to 9999. There is no year 0 -- the proleptic Gregorian calendar
'' this library uses starts at 0001-01-01.
print LocalDate.MinValue( ).Year          '' 1
print LocalDate.MaxValue( ).Year          '' 9999
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
