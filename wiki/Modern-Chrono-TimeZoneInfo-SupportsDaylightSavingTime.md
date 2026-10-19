[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeZoneInfo.SupportsDaylightSavingTime**

# TimeZoneInfo.SupportsDaylightSavingTime

Returns true if the local zone observes daylight saving time at all.

## Syntax

```freebasic
TimeZoneInfo.SupportsDaylightSavingTime( ) as boolean
```

## Notes

- False means the offset is the same all year, so `LocalOffset` is right for every moment.

## Examples

```freebasic
#import "std/chrono"
using chrono

if TimeZoneInfo.SupportsDaylightSavingTime( ) then
    print "daylight saving: " & TimeZoneInfo.DaylightName( )
else
    print "one offset all year"
end if
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
