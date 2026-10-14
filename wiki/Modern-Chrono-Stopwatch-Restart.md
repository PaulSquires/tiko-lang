[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Stopwatch.Restart**

# Stopwatch.Restart

## Syntax

```freebasic
Stopwatch.Restart
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim sw as Stopwatch
sw.Start( )
sleep 40, 1

sw.Restart( )                '' zero the accumulator and keep running
print sw.IsRunning           '' true
print sw.ElapsedMilliseconds < 40       '' -1 (true) -- the old time is gone

'' The shape for timing each iteration of a loop without declaring a new
'' Stopwatch every time round
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
