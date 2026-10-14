[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Stopwatch.Stop_**

# Stopwatch.Stop_

## Syntax

```freebasic
Stopwatch.Stop_
```

## Examples

```freebasic
#import "std/chrono"
using chrono

'' Spelled Stop_ WITH A TRAILING UNDERSCORE, because STOP is a
'' tiko statement
dim sw as Stopwatch

sw.Start( )
sleep 30, 1
sw.Stop_( )

print sw.IsRunning           '' false

'' Stopping banks the current segment; the elapsed time stops advancing
dim as int64 a = sw.ElapsedTicks
sleep 30, 1
print sw.ElapsedTicks = a    '' -1 (true) -- frozen while stopped
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
