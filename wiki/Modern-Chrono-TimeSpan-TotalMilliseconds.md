[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.TotalMilliseconds**

# TimeSpan.TotalMilliseconds

Returns the whole duration in milliseconds, with a fraction.

## Syntax

```freebasic
TimeSpan.TotalMilliseconds
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan t = TimeSpan.FromSeconds( 1.5 )

print t.TotalMilliseconds    '' 1500

'' A double, so it keeps the fraction below a millisecond
print TimeSpan.FromTicks( 5000 ).TotalMilliseconds       '' 0.5
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
