[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Stopwatch.Reset**

# Stopwatch.Reset

## Syntax

```freebasic
Stopwatch.Reset
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim sw as Stopwatch
sw.Start( )
sleep 30, 1
sw.Stop_( )

sw.Reset( )                  '' back to zero AND stopped
print sw.ElapsedTicks        '' 0
print sw.IsRunning           '' false

'' Reset then Start is Restart( )
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
