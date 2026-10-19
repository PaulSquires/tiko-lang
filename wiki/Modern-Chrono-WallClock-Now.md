[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **WallClock.Now**

# WallClock.Now

Returns the local date and time, with the UTC offset in force at this moment.

## Syntax

```freebasic
WallClock.Now( ) as DateTime
```

## Notes

- The offset is the one in force **at this instant**, and it is stored in the value, so `WallClock.Now( ).ToInstant( )` gives back the same moment even across a daylight-saving change.
- Use it for showing the time to a person; use `UtcNow` for anything stored or compared.
- **It can jump backwards** -- an NTP correction, a daylight-saving change or a user setting the clock moves it. To measure how long something takes use [Stopwatch](Modern-Chrono-Stopwatch-Stopwatch), which never jumps.

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = WallClock.Now( )

print d.HasOffset                                    '' true
print d.OffsetMinutes = TimeZoneInfo.LocalOffset( )  '' -1 (true)

'' The offset travels with the value, so it converts back to the
'' same moment on the UTC timeline
dim as TimeSpan gap = d.ToInstant( ) - WallClock.UtcNow( )
print abs( gap.TotalSeconds ) < 1                    '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
