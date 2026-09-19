[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Stopwatch.Stopwatch**

# Stopwatch.Stopwatch

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Stopwatch( )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' The MONOTONIC clock: how long since. It never jumps, so unlike TIMER
'' it stays correct across an NTP correction or a DST shift.
dim sw as Stopwatch

sw.Start( )
sleep 60, 1
sw.Stop_( )

print sw.ElapsedMilliseconds >= 50      '' -1 (true)

'' It ACCUMULATES rather than subtracting two stored timestamps, so
'' start/stop/start is correct with no special cases
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
