[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **WallClock.Today**

# WallClock.Today

Returns today's local date as a LocalDate.

## Syntax

```freebasic
WallClock.Today( ) as LocalDate
```

## Notes

- The same as `WallClock.Now( ).GetDate( )`: the date in the machine's zone, which is not always the UTC date.

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalDate today = WallClock.Today( )

print today.IsValid                   '' true
print len( today.ToIsoString( ) )     '' 10 -- yyyy-mm-dd
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
