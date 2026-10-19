[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **CpuClock.ProcessUserTime**

# CpuClock.ProcessUserTime

Returns the processor time this process has spent running its own code.

## Syntax

```freebasic
CpuClock.ProcessUserTime( ) as TimeSpan
```

## Notes

- The user half of `ProcessTime`; `ProcessKernelTime` is the other half.
- Invalid when the platform cannot report it.

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan u = CpuClock.ProcessUserTime( )

print u.IsValid                               '' true
print u.Ticks <= CpuClock.ProcessTime( ).Ticks '' -1 (true) -- one part of the total
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
