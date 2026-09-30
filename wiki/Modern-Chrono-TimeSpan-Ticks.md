[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Ticks**

# TimeSpan.Ticks

## Syntax

```freebasic
TimeSpan.Ticks
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim as TimeSpan t = TimeSpan.FromSeconds( 1 )

print t.Ticks                '' 10000000 -- 100 ns each

'' The whole value is this one LONGINT, which is why a TimeSpan passes
'' in a register and copies trivially
print TimeSpan.FromTicks( t.Ticks ).TotalSeconds        '' 1
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
