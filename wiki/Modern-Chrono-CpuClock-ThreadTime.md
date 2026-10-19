[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **CpuClock.ThreadTime**

# CpuClock.ThreadTime

Returns the processor time the calling thread has used, user and kernel together.

## Syntax

```freebasic
CpuClock.ThreadTime( ) as TimeSpan
```

## Notes

- Only the thread that calls it, where `ProcessTime` counts every thread.
- Always the total: there is no user/kernel split for a thread.
- Invalid when the platform cannot report it.

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan t0 = CpuClock.ThreadTime( )

dim as float64 x = 0
for i as int32 = 1 to 30000000 : x += sqr( i ) : next

print ( CpuClock.ThreadTime( ) - t0 ).TotalMilliseconds > 0   '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
