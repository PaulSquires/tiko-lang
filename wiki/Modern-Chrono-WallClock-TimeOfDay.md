[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **WallClock.TimeOfDay**

# WallClock.TimeOfDay

Returns the current local time of day as a LocalTime.

## Syntax

```freebasic
WallClock.TimeOfDay( ) as LocalTime
```

## Notes

- The same as `WallClock.Now( ).GetTimeOfDay( )`.
- Carries the clock's full precision, so `ToIsoString` normally shows seven fractional digits.

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalTime t = WallClock.TimeOfDay( )

print t.IsValid                       '' true
print mid( t.ToIsoString( ), 3, 1 )   '' : -- hh:mm:ss.fffffff
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
