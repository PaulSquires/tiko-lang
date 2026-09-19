[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Frequency**

# Frequency

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Ticks per second of the underlying monotonic counter.

## Syntax

```freebasic
Stopwatch.Frequency( ) as longint
```

## Notes

- The resolution of the **raw platform counter** that `GetTimestamp` returns -- not of `Elapsed`, which is always in 100 ns ticks whatever the hardware does.
- Needed only when working with `GetTimestamp` directly; `Elapsed` and `ElapsedMilliseconds` have already done the conversion.
- A static, and constant for the life of the process.

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print Stopwatch.Frequency( ) > 0              '' -1 (true)

'' Only needed with the raw counter -- Elapsed is already in 100 ns ticks
dim as longint a = Stopwatch.GetTimestamp( )
sleep 20, 1
dim as longint b = Stopwatch.GetTimestamp( )

print ( b - a ) / Stopwatch.Frequency( ) > 0  '' -1 (true), in seconds
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
