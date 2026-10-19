[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **WallClock.UtcNow**

# WallClock.UtcNow

Returns the current moment on the UTC timeline, read from the system clock.

## Syntax

```freebasic
WallClock.UtcNow( ) as Instant
```

## Notes

- An `Instant` has no offset: it is the same value whichever zone the machine is in, which makes it the right thing to store, compare and send.
- **It can jump backwards** -- an NTP correction, a daylight-saving change or a user setting the clock moves it. To measure how long something takes use [Stopwatch](Modern-Chrono-Stopwatch-Stopwatch), which never jumps.

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as Instant t = WallClock.UtcNow( )

print t.IsValid                       '' true
print right( t.ToIsoString( ), 1 )     '' Z -- always UTC
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
