[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Frequency**

# Frequency

Returns how many counts per second the raw counter from GetTimestamp makes.

## Syntax

```freebasic
Stopwatch.Frequency( ) as int64
```

## Notes

- The resolution of the **raw platform counter** that `GetTimestamp` returns -- not of `Elapsed`, which is always in 100 ns ticks whatever the hardware does.
- Needed only when working with `GetTimestamp` directly; `Elapsed` and `ElapsedMilliseconds` have already done the conversion.
- A static, and constant for the life of the process.

## Examples

```freebasic
#import "std/chrono"
using chrono

print Stopwatch.Frequency( ) > 0              '' -1 (true)

'' Only needed with the raw counter -- Elapsed is already in 100 ns ticks
dim as int64 a = Stopwatch.GetTimestamp( )
sleep 20, 1
dim as int64 b = Stopwatch.GetTimestamp( )

print ( b - a ) / Stopwatch.Frequency( ) > 0  '' -1 (true), in seconds
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** Members
