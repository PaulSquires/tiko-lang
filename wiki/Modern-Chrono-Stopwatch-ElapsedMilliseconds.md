[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Stopwatch.ElapsedMilliseconds**

# Stopwatch.ElapsedMilliseconds

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Stopwatch.ElapsedMilliseconds
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim sw as Stopwatch
sw.Start( )
sleep 60, 1
sw.Stop_( )

print sw.ElapsedMilliseconds >= 50      '' -1 (true)

'' The convenience form of Elapsed.TotalMilliseconds, as a whole number
'' of milliseconds rather than a fraction
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
