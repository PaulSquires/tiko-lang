[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.FromSeconds**

# TimeSpan.FromSeconds

Returns a duration of a number of seconds, fractions allowed.

## Syntax

```freebasic
TimeSpan.FromSeconds( v )
```

## Notes

- Takes a `float64`, so sub-second values survive down to the 100 ns tick.
- Rounds **half away from zero** below the tick.
- NaN or an out-of-range value yields Invalid.
- Below a millisecond, prefer `FromMicroseconds` or `FromTicks`: those take a `int64` and cannot lose a tick to floating point.

## Examples

```freebasic
#import "std/chrono"
using chrono

print TimeSpan.FromSeconds( 90 ).TotalMinutes    '' 1.5
print TimeSpan.FromSeconds( 1.5 ).TotalMilliseconds      '' 1500
print TimeSpan.FromSeconds( 1 ).Ticks             '' 10000000

'' A fraction below the millisecond still lands on a tick
print TimeSpan.FromSeconds( 0.0000001 ).Ticks     '' 1

print TimeSpan.FromSeconds( 1e300 ).IsValid       '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
