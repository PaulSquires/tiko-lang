[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.Midnight**

# LocalTime.Midnight

## Syntax

```freebasic
LocalTime.Midnight
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalTime t = LocalTime.Midnight( )

print t.Ticks                '' 0
print t.ToIsoString( )       '' 00:00:00

'' The start of the day, and the smallest valid LocalTime
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
