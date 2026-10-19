[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.EndOfMonth**

# DateTime.EndOfMonth

Returns the last tick of the last day of the month.

## Syntax

```freebasic
DateTime.EndOfMonth
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.EndOfMonth( ).ToIsoString( )     '' 2026-08-31T23:59:59.9999999
print d.EndOfMonth( ).Day                '' 31
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
