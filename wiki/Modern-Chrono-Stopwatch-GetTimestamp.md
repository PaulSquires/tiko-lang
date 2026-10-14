[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **GetTimestamp**

# GetTimestamp

The raw monotonic counter value.

## Syntax

```freebasic
Stopwatch.GetTimestamp( ) as int64
```

## Notes

- Platform units, **not** 100 ns ticks: divide a difference by `Frequency( )` to get seconds.
- It is the primitive a Stopwatch is built on, exposed for code that wants to time something without holding one.
- Monotonic, so it never goes backwards across an NTP correction or a DST change -- which `TIMER` does not promise.

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as int64 a = Stopwatch.GetTimestamp( )
sleep 20, 1
dim as int64 b = Stopwatch.GetTimestamp( )

print b > a                  '' -1 (true) -- monotonic

'' PLATFORM UNITS: divide by Frequency to get seconds
print ( b - a ) / Stopwatch.Frequency( ) < 1.0                '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** Members
