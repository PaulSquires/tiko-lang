[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.FromTicks**

# TimeSpan.FromTicks

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TimeSpan.FromTicks( longint )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' The tick is 100 ns, and is the unit everything here measures in
print TimeSpan.FromTicks( 10000000ll ).TotalSeconds     '' 1

'' Exact, with no rounding step at all -- the other From* functions
'' convert a double and round half away from zero to get here
print TimeSpan.FromTicks( 1 ).Ticks              '' 1
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
