[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.Second**

# LocalTime.Second

Returns the second, 0 to 59.

## Syntax

```freebasic
LocalTime.Second
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalTime t = LocalTime( 14, 30, 5, 0 )
print t.Second               '' 5

'' 0 to 59. There are no leap seconds in this library: a day is always
'' exactly 86400 seconds.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
