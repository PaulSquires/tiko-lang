[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **CpuClock.ProcessTime**

# CpuClock.ProcessTime

Returns the processor time this process has used so far, user and kernel together.

## Syntax

```freebasic
CpuClock.ProcessTime( ) as TimeSpan
```

## Notes

- A `sleep` does not advance it: it counts processor time used, not time passed. That is what makes it the right measure of how much work code does, and the wrong one for how long a user waits.
- Counts every thread of the process.
- Invalid when the platform cannot report it -- see `IsSupported`.
- It advances in the OS's accounting steps, which on Windows are often 15.625 ms, so measure work that takes well over that.

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan t0 = CpuClock.ProcessTime( )

dim as float64 x = 0
for i as int32 = 1 to 30000000 : x += sqr( i ) : next
dim as TimeSpan t1 = CpuClock.ProcessTime( )
print ( t1 - t0 ).TotalMilliseconds > 0     '' -1 (true) -- the loop used the processor

'' Sleeping uses none
sleep 200, 1
print ( CpuClock.ProcessTime( ) - t1 ).TotalMilliseconds < 50   '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
