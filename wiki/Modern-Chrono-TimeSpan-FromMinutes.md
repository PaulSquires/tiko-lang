[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.FromMinutes**

# TimeSpan.FromMinutes

Returns a duration of a number of minutes, fractions allowed.

## Syntax

```freebasic
TimeSpan.FromMinutes( v )
```

## Notes

- Takes a `float64`, so half a minute is exact.
- Rounds **half away from zero** below the tick.
- NaN or an out-of-range value yields Invalid.
- A minute is always 60 seconds: this library has no leap seconds.

## Examples

```freebasic
#import "std/chrono"
using chrono

print TimeSpan.FromMinutes( 90 ).TotalHours      '' 1.5
print TimeSpan.FromMinutes( 0.5 ).TotalSeconds    '' 30
print TimeSpan.FromMinutes( -90 ).ToIsoString( )  '' -PT1H30M

'' Components of a NEGATIVE span are ALL negative, so the pieces still
'' reconstruct the whole
dim as TimeSpan n = TimeSpan.FromMinutes( -90 )
print n.Hours & " " & n.Minutes                   '' -1 -30
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
