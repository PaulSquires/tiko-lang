[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Stopwatch.Stop_**

# Stopwatch.Stop_

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Stopwatch.Stop_
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' Spelled Stop_ WITH A TRAILING UNDERSCORE, because STOP is a
'' FreeBASIC statement
dim sw as Stopwatch

sw.Start( )
sleep 30, 1
sw.Stop_( )

print sw.IsRunning           '' false

'' Stopping banks the current segment; the elapsed time stops advancing
dim as longint a = sw.ElapsedTicks
sleep 30, 1
print sw.ElapsedTicks = a    '' -1 (true) -- frozen while stopped
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
