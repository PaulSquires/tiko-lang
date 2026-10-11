[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **StartNew**

# StartNew

Creates a Stopwatch and starts it in one step.

## Syntax

```freebasic
Stopwatch.StartNew( ) as Stopwatch
```

## Notes

- The one-liner for the common case, equivalent to constructing one and calling `Start`.
- A static: it is called on the type, not on an instance.
- The returned Stopwatch is already running, so `IsRunning` is TRUE.

## Examples

```freebasic
#import "std/chrono"
using chrono

dim sw as Stopwatch = Stopwatch.StartNew( )

print sw.IsRunning           '' true
sleep 40, 1
sw.Stop_( )

print sw.ElapsedMilliseconds >= 30            '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
