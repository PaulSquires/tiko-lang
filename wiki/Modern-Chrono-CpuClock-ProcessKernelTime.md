[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **CpuClock.ProcessKernelTime**

# CpuClock.ProcessKernelTime

Returns the processor time the OS has spent working on behalf of this process.

## Syntax

```freebasic
CpuClock.ProcessKernelTime( ) as TimeSpan
```

## Notes

- File, network and memory calls are where it grows: the time is spent in the OS, on this process's behalf.
- **Invalid** where the OS does not split user time from kernel time; `ProcessTime` still gives the total there.

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan k = CpuClock.ProcessKernelTime( )

if k.IsValid then
    print k.Ticks >= 0                         '' -1 (true)
else
    print "no user/kernel split here"
end if
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
