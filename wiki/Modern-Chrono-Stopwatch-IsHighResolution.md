[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **IsHighResolution**

# IsHighResolution

Returns true if the platform counter is finer than the system tick.

## Syntax

```freebasic
Stopwatch.IsHighResolution( ) as boolean
```

## Notes

- TRUE on every current desktop platform; it is FALSE only where the OS has no better clock than the system tick.
- When it is FALSE, a measurement below roughly 15 ms is noise rather than a number.
- A static, and constant for the life of the process.

## Examples

```freebasic
#import "std/chrono"
using chrono

print Stopwatch.IsHighResolution( )           '' true on a modern machine

'' When this is FALSE, anything under ~15 ms is noise rather than a
'' measurement
if Stopwatch.IsHighResolution( ) = false then print "coarse clock"
print "checked"
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** Members
