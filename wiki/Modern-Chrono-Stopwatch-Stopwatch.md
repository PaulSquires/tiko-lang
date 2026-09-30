[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Stopwatch.Stopwatch**

# Stopwatch.Stopwatch

## Syntax

```freebasic
Stopwatch( )
```

## Examples

```freebasic
#import "std/chrono"
using FB

'' The MONOTONIC clock: how long since. It never jumps, so unlike TIMER
'' it stays correct across an NTP correction or a DST shift.
dim sw as Stopwatch

sw.Start( )
sleep 60, 1
sw.Stop_( )

print sw.ElapsedMilliseconds >= 50      '' -1 (true)

'' It ACCUMULATES rather than subtracting two stored timestamps, so
'' start/stop/start is correct with no special cases
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
