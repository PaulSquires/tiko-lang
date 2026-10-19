[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.MaxValue**

# LocalTime.MaxValue

Returns the last tick of the day, 23:59:59.9999999.

## Syntax

```freebasic
LocalTime.MaxValue
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalTime t = LocalTime.MaxValue( )

print t.ToIsoString( )       '' 23:59:59.9999999 -- the last tick of the day
print t.Hour                 '' 23

'' NOT midnight of the next day: a LocalTime cannot represent 24:00
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
