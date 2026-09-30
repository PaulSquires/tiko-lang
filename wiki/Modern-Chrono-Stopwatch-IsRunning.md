[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Stopwatch.IsRunning**

# Stopwatch.IsRunning

## Syntax

```freebasic
Stopwatch.IsRunning
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim sw as Stopwatch
print sw.IsRunning           '' false

sw.Start( )
print sw.IsRunning           '' true

sw.Stop_( )
print sw.IsRunning           '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
