[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **CpuClock.IsSupported**

# CpuClock.IsSupported

Returns true if the platform can report processor time.

## Syntax

```freebasic
CpuClock.IsSupported( ) as boolean
```

## Notes

- When it is false the other CpuClock functions return an Invalid TimeSpan rather than a made-up number.

## Examples

```freebasic
#import "std/chrono"
using chrono

if CpuClock.IsSupported( ) then
    print CpuClock.ProcessTime( ).IsValid      '' true
end if
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
