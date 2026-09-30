[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Stopwatch.ElapsedTicks**

# Stopwatch.ElapsedTicks

## Syntax

```freebasic
Stopwatch.ElapsedTicks
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim sw as Stopwatch
sw.Start( )
sleep 30, 1
sw.Stop_( )

'' Ticks of 100 ns, the unit everything in this library measures in --
'' NOT the raw platform counter, which is what Stopwatch.GetTimestamp
'' returns
print sw.ElapsedTicks >= 200000         '' -1 (true), i.e. >= 20 ms
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
