[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.FromMilliseconds**

# TimeSpan.FromMilliseconds

rounds half away from zero

## Syntax

```freebasic
FromMilliseconds( float64 )
```

## Notes

- rounds half away from zero

## Examples

```freebasic
#import "std/chrono"
using chrono

print TimeSpan.FromMilliseconds( 1500 ).TotalSeconds     '' 1.5

'' ROUNDS HALF AWAY FROM ZERO, not to even and not by truncation. A
'' millisecond is 10000 ticks, so a fractional millisecond still lands
'' exactly on a tick.
print TimeSpan.FromMilliseconds( 0.15 ).Ticks    '' 1500
print TimeSpan.FromMilliseconds( 1.5 ).Ticks     '' 15000

'' NaN or a value beyond the representable span yields Invalid rather
'' than wrapping or saturating
print TimeSpan.FromMilliseconds( 1e300 ).IsValid '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
