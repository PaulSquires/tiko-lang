[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Stopwatch.Restart**

# Stopwatch.Restart

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Stopwatch.Restart
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim sw as Stopwatch
sw.Start( )
sleep 40, 1

sw.Restart( )                '' zero the accumulator and keep running
print sw.IsRunning           '' true
print sw.ElapsedMilliseconds < 40       '' -1 (true) -- the old time is gone

'' The shape for timing each iteration of a loop without declaring a new
'' Stopwatch every time round
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
