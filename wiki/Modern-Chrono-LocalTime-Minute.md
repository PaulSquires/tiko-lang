[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.Minute**

# LocalTime.Minute

Returns the minute, 0 to 59.

## Syntax

```freebasic
LocalTime.Minute
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalTime t = LocalTime( 14, 30, 5, 0 )
print t.Minute               '' 30
print LocalTime.Midnight( ).Minute      '' 0
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
