[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.FromTicks**

# LocalTime.FromTicks

## Syntax

```freebasic
LocalTime.FromTicks
```

## Examples

```freebasic
#import "std/chrono"
using chrono

'' Ticks since midnight, 100 ns each
dim as LocalTime t = LocalTime.FromTicks( 36000000000ll )    '' one hour

print t.Hour                 '' 1
print t.Ticks                '' 36000000000

'' A tick count at or past a whole day is out of range
dim as LocalTime bad = LocalTime.FromTicks( 864000000000ll )
print bad.IsValid            '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
