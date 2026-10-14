[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.TotalSeconds**

# TimeSpan.TotalSeconds

## Syntax

```freebasic
TimeSpan.TotalSeconds
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan t = TimeSpan( 0, 1, 30 )           '' 1m 30s

print t.TotalSeconds         '' 90
print t.Seconds              '' 30

'' Fractional, so sub-second precision survives
print TimeSpan.FromMilliseconds( 1500 ).TotalSeconds    '' 1.5
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
