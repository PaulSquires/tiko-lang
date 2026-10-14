[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Stopwatch.ElapsedMilliseconds**

# Stopwatch.ElapsedMilliseconds

## Syntax

```freebasic
Stopwatch.ElapsedMilliseconds
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim sw as Stopwatch
sw.Start( )
sleep 60, 1
sw.Stop_( )

print sw.ElapsedMilliseconds >= 50      '' -1 (true)

'' The convenience form of Elapsed.TotalMilliseconds, as a whole number
'' of milliseconds rather than a fraction
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
