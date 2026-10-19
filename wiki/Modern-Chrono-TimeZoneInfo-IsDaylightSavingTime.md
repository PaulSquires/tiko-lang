[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeZoneInfo.IsDaylightSavingTime**

# TimeZoneInfo.IsDaylightSavingTime

Returns true if daylight saving time is in force in the local zone at a given moment.

## Syntax

```freebasic
TimeZoneInfo.IsDaylightSavingTime( byref i as Instant ) as boolean
```

## Notes

- Asks about a given moment, like `LocalOffsetAt`, so a past or future timestamp gets the rule that applied to it.
- Always false in a zone without daylight saving, and for an Invalid instant.

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as Instant jan = DateTime( 2026, 1, 15, 12, 0, 0, 0 ).AssumeUtc( )
dim as Instant jul = DateTime( 2026, 7, 15, 12, 0, 0, 0 ).AssumeUtc( )

'' In a northern-hemisphere zone with daylight saving: false, true
print TimeZoneInfo.IsDaylightSavingTime( jan ), TimeZoneInfo.IsDaylightSavingTime( jul )

print TimeZoneInfo.IsDaylightSavingTime( Instant.Invalid( ) )   '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
