[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Stopwatch.Elapsed**

# Stopwatch.Elapsed

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Stopwatch.Elapsed
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim sw as Stopwatch
sw.Start( )
sleep 60, 1
sw.Stop_( )

'' A TimeSpan, so it prints and composes like any other duration
dim as TimeSpan took = sw.Elapsed
print took.TotalMilliseconds >= 50      '' -1 (true)
print took.ToIsoString( )               '' PT0.0xxS

'' A property over an ACCUMULATOR, not a subtraction of endpoints --
'' which is what makes start/stop/start add up correctly
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
