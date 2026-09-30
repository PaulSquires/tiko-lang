[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Stopwatch.Start**

# Stopwatch.Start

## Syntax

```freebasic
Stopwatch.Start
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim sw as Stopwatch
print sw.IsRunning           '' false -- a fresh Stopwatch is stopped

sw.Start( )
print sw.IsRunning           '' true

'' Start after a Stop RESUMES: the banked time is kept and a new segment
'' begins. Restart( ) is the one that zeroes first.
sw.Stop_( )
dim as longint banked = sw.ElapsedTicks
sw.Start( )
print sw.ElapsedTicks >= banked         '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
