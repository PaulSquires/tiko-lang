[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeZoneInfo.LocalOffset**

# TimeZoneInfo.LocalOffset

Returns the local zone's UTC offset in minutes right now.

## Syntax

```freebasic
TimeZoneInfo.LocalOffset( ) as int16
```

## Notes

- Right for the current time and wrong for any other: for a stored timestamp use `LocalOffsetAt`, which applies the rule in force at that moment.
- Minutes east of UTC: a zone behind UTC gives a negative number.

## Examples

```freebasic
#import "std/chrono"
using chrono

print TimeZoneInfo.LocalOffset( ) = TimeZoneInfo.LocalOffsetAt( WallClock.UtcNow( ) )   '' -1 (true)

'' The offset WallClock.Now stamps on its value
print WallClock.Now( ).OffsetMinutes = TimeZoneInfo.LocalOffset( )                     '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
