[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.Ticks**

# LocalTime.Ticks

Returns the time of day as 100 ns ticks since midnight.

## Syntax

```freebasic
LocalTime.Ticks
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalTime t = LocalTime( 1, 0, 0, 0 )

print t.Ticks                '' 36000000000 -- one hour in 100 ns ticks

'' The whole value is this one number, which is why a LocalTime passes
'' in a register and copies trivially
print t.Ticks / DT_TICKS_PER_HOUR       '' 1
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
