[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Stopwatch.Start**

# Stopwatch.Start

Starts the stopwatch, or resumes it and keeps the time already measured.

## Syntax

```freebasic
Stopwatch.Start
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim sw as Stopwatch
print sw.IsRunning           '' false -- a fresh Stopwatch is stopped

sw.Start( )
print sw.IsRunning           '' true

'' Start after a Stop RESUMES: the banked time is kept and a new segment
'' begins. Restart( ) is the one that zeroes first.
sw.Stop_( )
dim as int64 banked = sw.ElapsedTicks
sw.Start( )
print sw.ElapsedTicks >= banked         '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
