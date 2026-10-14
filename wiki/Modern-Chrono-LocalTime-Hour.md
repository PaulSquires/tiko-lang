[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.Hour**

# LocalTime.Hour

## Syntax

```freebasic
LocalTime.Hour
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalTime t = LocalTime( 14, 30, 5, 0 )
print t.Hour                 '' 14

'' 0 to 23. There is no 12-hour form and no AM/PM here -- that is a
'' formatting concern, not a component one.
print LocalTime.Midnight( ).Hour        '' 0
print LocalTime.Noon( ).Hour            '' 12
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
